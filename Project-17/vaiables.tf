variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

#Cognito User pool name
variable "user_pool_name" {
  description = "User pool name"
  type        = string
  default     = "tcf33_tf_demoUserPool"
}

#Cognito User pool client name
variable "app_client_name" {
  description = "App Client name"
  type        = string
  default     = "tcf33_demo_AppClient"
}

#app client callback url
variable "callback_url" {
  description = "App client callback url"
  type        = string
  default     = "https://example.com/signin"
}

#app client logout url
variable "logout_url" {
  description = "App client callback url"
  type        = string
  default     = "https://example.com/signout"
}

#Cognito domain name
variable "domain_prefix" {
  description = "Domain name"
  type        = string
  default     = "example-domain0416"
}

#OAuth 2.0 Client id
variable "OAuth_client_id" {
  description = "OAuth Client Id"
  type        = string
  default     = "843096753386-sbvivvc2avqvm0pimo1rkko4rlgtejtd.apps.googleusercontent.com"
}

#OAuth 2.0 Client secret
variable "OAuth_client_secret" {
  description = "OAuth Client secret"
  type        = string
  default     = "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"
}

