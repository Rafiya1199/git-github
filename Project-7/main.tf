terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an archive from a file
# ${path.module} is the current directory
data "archive_file" "zip_python_code"{
    type        = "zip"
    source_file  = "${path.module}/python/hello-python.py"
    output_file_mode = "0666"
    output_path = "${path.module}/builds/hello-python.zip"
}

# Create a Lambda function
resource "aws_lambda_function" "tf_lambda_func" {
    depends_on = [data.archive_file.zip_python_code]
    filename       = "${path.module}/builds/hello-python.zip"
    function_name  = "tcf23-Lambda-Function"
    role           =  var.lambda_role_arn
    handler        = "hello-python.lambda_handler"
    runtime        = "python3.9"
    source_code_hash = filebase64sha256("${path.module}/builds/hello-python.zip")
}

#Create an ec2 instance. Switch tags on the instance to test your trigger
module "ec2_instances" {
  source  = "../ec2-session-manager"
  count   = 1
  
  name = "my-ec2-cluster"
  associate_public_ip_address = true
  tags = var.tags

}

#Create a CloudWatch event rule
#use join to flatten the tuple (module.ec2_instances[0].arn) to a string
resource "aws_cloudwatch_event_rule" "CW_rule" {
  depends_on = [module.ec2_instances]
  name        = "capture-tag-change"
  description = "Capture tag update on ec2"
  event_pattern = <<EOF
  {
  "source": ["aws.tag"],
  "detail-type": ["Tag Change on Resource"],
  "region": ["us-east-1"],
  "resources": ["${join("\",\"", module.ec2_instances[0].arn)}"],
  "detail": {
    "service": ["ec2"],
    "resource-type": ["instance"]
  }
}
EOF
}

# Specify a target
resource "aws_cloudwatch_event_target" "trigger_lambda" {
    rule = aws_cloudwatch_event_rule.CW_rule.name
    target_id = "terraform_lambda"
    arn = aws_lambda_function.tf_lambda_func.arn
}

# give permission required for EventBridge to invoke your Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_lambda_func.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CW_rule.arn
}
