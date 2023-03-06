variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "account_ID" {
  description = "AWS Account ID"
  type        = string
  default     = "089999148961"
}

#Cognito User pool name
variable "user_pool_name" {
  description = "User pool name"
  type        = string
  default     = "tcf30_UserPool"
}

#Cognito Identity pool name
variable "identity_pool_name" {
  description = "Identity pool name"
  type        = string
  default     = "tcf30_identity_pool"
}

#Cognito User pool client name
variable "app_client_name" {
  description = "App Client name"
  type        = string
  default     = "tcf30_AppClient"
}

#Cognito domain name
variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "example-domain0453"
}

#Cognito User pool user1 name
variable "user1_name" {
  description = "User1 name"
  type        = string
  default     = "Rafiya"
}

#Cognito User pool user1 password
variable "user1_password" {
  description = "User1 password"
  type        = string
  default     = "Rafiya123!"
}

#Cognito User pool user2 name
variable "user2_name" {
  description = "User2 name"
  type        = string
  default     = "Shameem"
}

#Cognito User pool user2 password
variable "user2_password" {
  description = "User2 password"
  type        = string
  default     = "Shameem123!"
}

#Cognito User pool group1 name
variable "group1_name" {
  description = "group1 name"
  type        = string
  default     = "movies"
}

#Cognito User pool group2 name
variable "group2_name" {
  description = "group2 name"
  type        = string
  default     = "shows"
}

variable "group1_role_name" {
  description = "group1 IAM role name"
  type        = string
  default     = "role_movies"
}

variable "group2_role_name" {
  description = "group2 IAM role name"
  type        = string
  default     = "role_shows"
}

variable "api_name" {
  description = "REST API name"
  type        = string
  default     = "tcf30_DemoApi"
}

variable "api_stage_name" {
  description = "API stage name"
  type        = string
  default     = "test"
}

variable "lambda_fn1_name" {
  description = "Lambda function1 name"
  type        = string
  default     = "tcf30_movies_lambda"
}

variable "lambda_fn2_name" {
  description = "Lambda function2 name"
  type        = string
  default     = "tcf30_shows_lambda"
}