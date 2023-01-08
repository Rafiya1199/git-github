variable "lambda_role_arn" {
  description = "ARN for lambda IAM role"
  default     = "arn:aws:iam::XXXXXXXXXXXX:role/lambda-role"
}

variable "cron_expression" {
  description = "Cron expression for cloud watch evnt rule."
  type        = string
  default     = "cron(0 8 1 * ? *)"
}
