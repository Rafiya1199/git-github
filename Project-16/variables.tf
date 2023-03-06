variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "account_ID" {
  description = "AWS Account ID"
  type        = string
  default     = "089999148961"
}

variable "api_name" {
  description = "Public REST API name"
  type        = string
  default     = "tcf32_DemoApi"
}

variable "api_endpoint1" {
  description = "API reseource endpoint1"
  type        = string
  default     = "movies"
}

variable "api_endpoint2" {
  description = "API reseource endpoint2"
  type        = string
  default     = "shows"
}

variable "api_stage_name" {
  description = "API stage name"
  type        = string
  default     = "test"
}

variable "lambda_fn1_name" {
  description = "Lambda function1 name"
  type        = string
  default     = "tcf32_movies_lambda"
}

variable "lambda_fn2_name" {
  description = "Lambda function2 name"
  type        = string
  default     = "tcf32_shows_lambda"
}

#Cognito User pool name
variable "user_pool_name" {
  description = "User pool name"
  type        = string
  default     = "tcf32_UserPool"
}

#Cognito User pool user1 name
variable "user_name" {
  description = "User1 name"
  type        = string
  default     = "Rafiya"
}

#Cognito User pool user1 password
variable "user_password" {
  description = "User1 password"
  type        = string
  default     = "Rafiya123!"
}

#Cognito domain name
variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "example-domain0453"
}

#Cognito User pool client name
variable "app_client_name" {
  description = "App Client name"
  type        = string
  default     = "tcf32_AppClient"
}