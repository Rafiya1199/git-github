variable "aws_region" {
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
}

variable "email_id" {
  description = "Sender email address for SES service to send the email."
  default     = "{email_id}"
}

variable "lambda_function_name" {
  description = "lambda function name"
  default     = "sendContactEmail"
}

variable "api_name" {
  description = "HTTP API name"
  default     = "sendContactEmail-API"
}
