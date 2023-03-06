variable "lambda_function_name" {
  type    = string
  default = "test_lambda_tcf11_fix"
}

variable "lambda_version" {
  type    = number
  default = 1
}

variable "lambda_alias_version" {
  type    = number
  default = 1
}

variable "function_code" {
  description = "lambda function code"
  type        = string
  default     = "hello-lambda.zip"
}

variable "lambda_alias_name" {
  description = "alias of lambda which will be deployed by CodeDeploy"
  type        = string
  default     = "my_lambda_alias"
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN of lambda IAM role"
  default     = "arn:aws:iam::XXXXXXXXXXXX:role/lambda-role"
}
