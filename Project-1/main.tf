terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

# Create an archive from a file or directory of files
# In terraform ${path.module} is the current directory
data "archive_file" "zip_the_python_code"{
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/python/hello-python.zip"
}

# Create Lambda Layer Version resource. Lambda Layers allow you to reuse shared bits of code across multiple lambda functions.
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/python/hello-python.zip"
  layer_name = "lambda_layer_python"

  compatible_runtimes = ["python3.9"]
}

# Create a Lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
    filename       = "${path.module}/python/hello-python.zip"
    function_name  = "TCF-Lambda-Function"
    role           =  var.lambda_role_arn
    handler        = "hello-python.lambda_handler"
    runtime        = "python3.9"
    layers         = [aws_lambda_layer_version.lambda_layer.arn]
}

# define a rule with the relevant schedule expression (8:00 AM on the first day of the month)
resource "aws_cloudwatch_event_rule" "schedule" {
    name = "schedule"
    description = "Schedule for Lambda Function"
    schedule_expression = var.cron_expression
}

# Specify a target
resource "aws_cloudwatch_event_target" "schedule_lambda" {
    rule = aws_cloudwatch_event_rule.schedule.name
    target_id = "terraform_lambda"
    arn = aws_lambda_function.terraform_lambda_func.arn
}

# give permission required for EventBridge to invoke your Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
