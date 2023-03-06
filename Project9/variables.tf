variable "aws_region" {
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
}

variable "email_id" {
  description = "Sender email address for SES service to send the email."
  default     = "rmohamed@thecloudforce.com"
}

variable "lambda_function_name" {
  description = "lambda function name"
  default     = "contactUs_lambda"
}

variable "api_name" {
  description = "REST API name"
  default     = "contactUs-API"
}

variable "domain_name1" {
   description = "Custom Domain1 name"
   default     = "contactusrestapi.dev.thecloudforce.net"
 }

variable "domain_name2" {
   description = "Custom Domain2 name"
   default     = "contactusrestapi-prod.dev.thecloudforce.net"
 }
 
variable "certificate_arn" {
   description = "ACM certificate arn"
   default     = "arn:aws:acm:us-east-1:089999148961:certificate/8559a4da-44e9-493e-81c5-73167374b587"
 }
 
variable "zone_id" {
   description = "Route53 Hosted Zone ID"
   default     = "Z06651351G8TQEE8INZSB"
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
  default     = "tcf36_UserPool"
}

#Cognito Identity pool name
variable "identity_pool_name" {
  description = "Identity pool name"
  type        = string
  default     = "tcf36_identity_pool"
}

#Cognito User pool client name
variable "app_client_name" {
  description = "App Client name"
  type        = string
  default     = "tcf36_AppClient"
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