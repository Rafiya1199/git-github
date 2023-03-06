terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}


provider "aws" {
    region = var.aws_region
}

#Creates a API Gateway REST API. 
resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  description = "Demo API with cognito scopes"
}

#Creates a API Gateway Resource endpoint
resource "aws_api_gateway_resource" "resource1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_endpoint1
}

#Creates another API Gateway Resource endpoint
resource "aws_api_gateway_resource" "resource2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_endpoint2
}

resource "aws_api_gateway_authorizer" "this" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  provider_arns = [aws_cognito_user_pool.user_pool.arn]
}

#Creates a HTTP Method for API Gateway Resource1.
resource "aws_api_gateway_method" "method1" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource1.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
  authorization_scopes = "${ aws_cognito_resource_server.resource_server.scope_identifiers }"
}
#Creates a HTTP Method for API Gateway Resource2.
resource "aws_api_gateway_method" "method2" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource2.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
  authorization_scopes = "${ aws_cognito_resource_server.resource_server.scope_identifiers }"
}

#Creates an HTTP Method Integration for an API Gateway Integration. Each method on an API gateway 
#resource has an integration which specifies where incoming requests are routed (in this case to lambda)
resource "aws_api_gateway_integration" "lambda1" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource1.id
  http_method             = aws_api_gateway_method.method1.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_fn_1.invoke_arn
}

resource "aws_api_gateway_integration" "lambda2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource2.id
  http_method             = aws_api_gateway_method.method2.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_fn_2.invoke_arn
}

# Create an archive from a file
# ${path.module} is the current directory
# index.js file will be executed when your lambda is called
data "archive_file" "zip_movies_code"{
    type        = "zip"
    source_file  = "${path.module}/code/index1.js"
    output_file_mode = "0666"
    output_path = "${path.module}/builds/index1.zip"
}

data "archive_file" "zip_shows_code"{
    type        = "zip"
    source_file  = "${path.module}/code/index2.js"
    output_file_mode = "0666"
    output_path = "${path.module}/builds/index2.zip"
}

#Create lambda function1 for API Gateway Integration
resource "aws_lambda_function" "lambda_fn_1" {
  filename       = "${path.module}/builds/index1.zip"
  function_name = var.lambda_fn1_name
  role          =  aws_iam_role.lambda-role.arn
  handler       = "index1.handler"
  runtime       = "nodejs18.x"

  source_code_hash = filebase64sha256("${path.module}/builds/index1.zip")
}

##Create lambda function2 for API Gateway Integration
resource "aws_lambda_function" "lambda_fn_2" {
  filename      = "${path.module}/builds/index2.zip"
  function_name = var.lambda_fn2_name
  role          =  aws_iam_role.lambda-role.arn
  handler       = "index2.handler"
  runtime       = "nodejs18.x"

  source_code_hash = filebase64sha256("${path.module}/builds/index2.zip")
}

#Gives API gateway permission to access the Lambda function1.
resource "aws_lambda_permission" "apigw_lambda1" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fn_1.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_ID}:${aws_api_gateway_rest_api.api.id}/*/*"
}

#Gives API gateway permission to access the Lambda function2.
resource "aws_lambda_permission" "apigw_lambda2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fn_2.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_ID}:${aws_api_gateway_rest_api.api.id}/*/*"
}

# Create API Gateway REST Deployment which is a snapshot of the REST API configuration.
# Expose the API at a URL that can be used for testing
resource "aws_api_gateway_deployment" "example" {
     depends_on = [
     aws_api_gateway_integration.lambda1,
     aws_api_gateway_integration.lambda2,
   ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.api_stage_name
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf32_publicApi_with_scopes/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}