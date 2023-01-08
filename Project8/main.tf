terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

#Create an SES email identity resource
resource "aws_ses_email_identity" "email_id" {
  email = var.email_id
}

# Create an archive from a file
# ${path.module} is the current directory
# index.js file will be executed when your lambda is called
data "archive_file" "zip_python_code"{
    type        = "zip"
    source_file  = "${path.module}/code/index.js"
    output_file_mode = "0666"
    output_path = "${path.module}/builds/index.zip"
}

# Create a Lambda function
resource "aws_lambda_function" "tf_lambda_func" {
    filename       = "${path.module}/builds/index.zip"
    function_name  = var.lambda_function_name
    role           =  aws_iam_role.tcf25_lambda_role.arn
    handler        = "index.handler"
    runtime        = "nodejs14.x"
    source_code_hash = filebase64sha256("${path.module}/builds/index.zip")
}

# Set up Amazon API Gateway Version 2 resources, used for creating and deploying  HTTP APIs
# enable CORS (Cross-origin resource sharing) to allow requests to your API from a web application hosted on a different domain.
resource "aws_apigatewayv2_api" "lambda" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = "API Gwy HTTP API and AWS Lambda function"
    cors_configuration {
      allow_credentials = false
      allow_headers     = []
      allow_methods     = ["*",]
      allow_origins     = ["*",]
      expose_headers    = []
      max_age           = 0
  }
}

#Create Amazon API Gateway Version 2 stage
# Use access_log_settings to specify settings for logging access in this stage.
#format - used to format log data
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      errormsg                = "$context.error.message"
      errorResponseType       = "$context.error.responseType"
      }
    )
  }
  depends_on = [aws_cloudwatch_log_group.api_gw]
}

#Set up Amazon API Gateway Version 2 integration
#Lambda proxy integration enables you to integrate an API route with a Lambda function.
resource "aws_apigatewayv2_integration" "app" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.tf_lambda_func.invoke_arn
  integration_type   = "AWS_PROXY"
}

#Set up Amazon API Gateway Version 2 route
#Routes direct incoming API requests to backend resources
resource "aws_apigatewayv2_route" "any" {
  api_id = aws_apigatewayv2_api.lambda.id
  route_key = "POST /sendContactEmail"
  target    = "integrations/${aws_apigatewayv2_integration.app.id}"
}

#Create a log group for the API
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"
}

#Grant permissions for API gateway to invoke lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*/sendContactEmail"
}
