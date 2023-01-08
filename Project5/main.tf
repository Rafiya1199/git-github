#provider "aws" block configures the AWS provider. 
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

#module "vpc" block configures a Virtual Private Cloud (VPC) module,
#which provisions networking resources such as a VPC, subnets, and internet and NAT gateways based on the arguments provided.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  single_nat_gateway   = var.vpc_single_nat_gateway
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.vpc_tags
}

#module "ec2_instances" block defines EC2 instances provisioned within the VPC created by the module.
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"
  count   = 1

  name = "my-ec2-cluster"

  ami                    = "ami-0b0dcb5067f052a63"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#Create a interface vpc endpoint
resource "aws_vpc_endpoint" "vpc_endpoint" {
  service_name        = "com.amazonaws.us-east-1.execute-api"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = [module.vpc.private_subnets[0]]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpc.default_security_group_id]
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
  name        = "myapi"
  description = "This is my API for demonstration purposes"

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.vpc_endpoint.id]
  }
}

# Create API resource policy
resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${aws_api_gateway_rest_api.api.execution_arn}/*/*",
            "Condition" : {
              "StringNotEquals": {
                "aws:SourceVpce": "${aws_vpc_endpoint.vpc_endpoint.id}"
          }
        }      
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
  role          = var.lambda_role_arn
  handler       = "code.handler"
  runtime       = "nodejs14.x"

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
