variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "account_ID" {
  description = "AWS Account ID"
  type        = string
  default     = "XXXXXXXXXXXX"
}

variable "lambda_role_arn" {
  description = "IAM role ARN for lambda function"
  type        = string
  default     = "arn:aws:iam::XXXXXXXXXXXX:role/lambda-role"
}
