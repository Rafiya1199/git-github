variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "image_uri" {
  type     = string
  default  = "089999148961.dkr.ecr.us-east-1.amazonaws.com/base-images:lambdaUbuntu"
}

variable "lambda_role_arn" {
  type     = string
  default  = "arn:aws:iam::089999148961:role/lambda-role"
}