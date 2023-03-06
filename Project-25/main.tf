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

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf46_ecs_fargate_autoscaling/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}