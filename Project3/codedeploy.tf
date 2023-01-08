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
#IAM role for CodeDeploy
resource "aws_iam_role" "codeDeploy_role" {
  name = "codeDeploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
#IAM policy for codedeploy role
resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "codedeploy_policy"
  role = aws_iam_role.codeDeploy_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
#IAM policy attachment for codedeploy role
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
  role       = aws_iam_role.codeDeploy_role.name
}

#Create a CodeDeploy Lambda application to be used as a basis for deployments
resource "aws_codedeploy_app" "sample" {
  compute_platform = "Lambda"
  name             = "hello-world-app"
  tags = {
    Project     = "TCF",
    Environment = "Dev"
  }
}


#Deployment Group for a CodeDeploy Lambda Application
resource "aws_codedeploy_deployment_group" "sample" {
  app_name               = aws_codedeploy_app.sample.name
  deployment_group_name  = "HW_group"
  service_role_arn       = aws_iam_role.codeDeploy_role.arn
  deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  tags = {
    Project     = "TCF",
    Environment = "Dev"
  }
}

#When lambda is deployed for the first time, the variables lambda_version & lambda_alias_version is equal to 1.
#After the initial execution, the variables lambda_version & lambda_alias_version are updated (lambda_version > lambda_alias_version)
resource "null_resource" "example1" {
  triggers = {
    lambda_version = var.lambda_version
  }
  #update the zip file when the lambda function code has to be updated.
  provisioner "local-exec" {
    command = "if [ ${var.lambda_version} -ne 1 ] ;then aws lambda update-function-code --function-name ${var.lambda_function_name} --zip-file fileb://python/${var.function_code} --publish;fi"
  }
}
# Trigger of deployment
resource "null_resource" "run_codedeploy" {
  triggers = {
    # Run codedeploy when lambda version is updated
    lambda_version = var.lambda_version
  }

  provisioner "local-exec" {
    # Only trigger deploy when lambda version is updated (=lambda version is not 1)
    command = "if [ ${var.lambda_version} -ne 1 ] ;then aws deploy create-deployment --application-name ${aws_codedeploy_app.sample.name} --deployment-group-name ${aws_codedeploy_deployment_group.sample.deployment_group_name} --revision '{\"revisionType\":\"AppSpecContent\",\"appSpecContent\":{\"content\":\"{\\\"version\\\":0,\\\"Resources\\\":[{\\\"${var.lambda_function_name}\\\":{\\\"Type\\\":\\\"AWS::Lambda::Function\\\",\\\"Properties\\\":{\\\"Name\\\":\\\"${var.lambda_function_name}\\\",\\\"Alias\\\":\\\"${var.lambda_alias_name}\\\",\\\"CurrentVersion\\\":\\\"${var.lambda_alias_version}\\\",\\\"TargetVersion\\\":\\\"${var.lambda_version}\\\"}}}]}\"}}';fi"
 
  }
}
