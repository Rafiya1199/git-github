terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}
## Create the lambda function
resource "aws_lambda_function" "tcf44-lambda-function" {
function_name = "tcf44-lambda-function"
description   = "lambda function using image"
image_uri     = var.image_uri
package_type  = "Image"
architectures = ["x86_64"]
role          = var.lambda_role_arn
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf44_lambda_with_image/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}