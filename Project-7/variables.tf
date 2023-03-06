variable "lambda_role_arn" {
  description = "ARN for lambda IAM role"
  default     = "arn:aws:iam::XXXXXXXXXXXX:role/lambda-role"
}

# Tags
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {
        webserver = "test",
        Group = "production"
  }
}
