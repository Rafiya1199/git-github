variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "bucket_name" {
    type        = string
    description = "S3 bucket name"
    default     = "tcf40-testbucket-3271"
}

# Tags
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {
        Project     = "TCF",
        Environment = "Dev"
  }
}