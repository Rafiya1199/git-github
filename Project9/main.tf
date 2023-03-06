terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.52.0"
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
    role           =  aws_iam_role.tcf36_lambda_role.arn
    handler        = "index.handler"
    runtime        = "nodejs14.x"
    source_code_hash = filebase64sha256("${path.module}/builds/index.zip")
}

data "template_file" "contactUsApi" {
  template = "${file("contactUsApi_OA3.0.yaml")}"


  vars = {
    get_lambda_arn          = "${aws_lambda_function.tf_lambda_func.arn}"
    aws_region              = var.aws_region
    # stage_name              = "${aws_api_gateway_stage.example.stage_name}"
  }

}

resource "aws_api_gateway_rest_api" "restful_api" {
 name = var.api_name
 body = "${data.template_file.contactUsApi.rendered}"
 endpoint_configuration {
    types = ["REGIONAL"]
  }
} 

#Grant permissions for API gateway to invoke lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restful_api.execution_arn}/*/*"
}

# Create API Gateway REST Deployment which is a snapshot of the REST API configuration.
# Expose the API at a URL that can be used for testing
resource "aws_api_gateway_deployment" "example" {
  triggers = {
    redeployment = "${data.template_file.contactUsApi.rendered}"
  }
  rest_api_id = aws_api_gateway_rest_api.restful_api.id
}
resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.restful_api.id
  stage_name    = "dev"
}

resource "aws_api_gateway_deployment" "example2" {
  triggers = {
    redeployment = "${data.template_file.contactUsApi.rendered}"
  }
  rest_api_id = aws_api_gateway_rest_api.restful_api.id
}
resource "aws_api_gateway_stage" "stage2" {
  deployment_id = aws_api_gateway_deployment.example2.id
  rest_api_id   = aws_api_gateway_rest_api.restful_api.id
  stage_name    = "prod"
}

#Create a custom domain
resource "aws_api_gateway_domain_name" "example" {
  domain_name              = var.domain_name1
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#Create an A record using Route53.
resource "aws_route53_record" "example" {
  name    = aws_api_gateway_domain_name.example.domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
  }
}

#Connects a custom domain name registered via aws_api_gateway_domain_name 
#with a deployed API so that its methods can be called via the custom domain name.
resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.restful_api.id
  stage_name  = aws_api_gateway_stage.example.stage_name
  domain_name = aws_api_gateway_domain_name.example.domain_name
}

resource "aws_api_gateway_domain_name" "example2" {
  domain_name              = var.domain_name2
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "example2" {
  name    = aws_api_gateway_domain_name.example2.domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example2.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example2.regional_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "example2" {
  api_id      = aws_api_gateway_rest_api.restful_api.id
  stage_name  = aws_api_gateway_stage.stage2.stage_name
  domain_name = aws_api_gateway_domain_name.example2.domain_name
}
#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/contactusApi_with_openapi3.0/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}