terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

#IAM role for API gateway
resource "aws_iam_role" "api_gateway_role" {
  name = "api_gateway_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
#IAM policy for API gateway
resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.api_gateway_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.lambda.arn}" 
    
    }
  ]
}
EOF
}


#Creates an API Gateway REST API. create a Private REST API that is only accessible from within a VPC, 
#you can use REST APIs with private endpoint type. This means the traffic will not leave the AWS network.
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
  description = "This is my API for demonstration purposes"
}

# Create API resource policy
resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
        }
    ]
  }
EOF
}

#Creates an API Gateway Resource.
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

# Create a API authorizer of type COGNITO_USER_POOLS
resource "aws_api_gateway_authorizer" "cognito" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  provider_arns = [aws_cognito_user_pool.royal_user_pool.arn]
}

#Creates a HTTP Method for an API Gateway Resource.
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

#Creates an HTTP Method Integration for an API Gateway Integration. Each method on an API gateway 
#resource has an integration which specifies where incoming requests are routed (in this case to lambda)
#AWS_PROXY integration type causes API gateway to call into the API of lambda to invoke lambda function
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}


#Create a lambda function
resource "aws_lambda_function" "lambda" {
  filename      = "code-js.zip"
  function_name = "lambda_and_api"
  role          =  var.lambda_role_arn
  handler       = "code.handler"
  runtime       = "nodejs16.x"

  source_code_hash = filebase64sha256("code-js.zip")
}

#Gives API gateway permission to access the Lambda function.
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_ID}:${aws_api_gateway_rest_api.api.id}/*/*"
}

# Create API Gateway REST Deployment which is a snapshot of the REST API configuration.
# Expose the API at a URL that can be used for testing
resource "aws_api_gateway_deployment" "example" {
     depends_on = [
     aws_api_gateway_integration.lambda,
   ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "DEV"
}
# Get the base URL for the API
output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "Lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}
