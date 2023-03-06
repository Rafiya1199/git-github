terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

# Create a cognito user pool
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  email_verification_subject = "Your Verification Code"
  email_verification_message = "Please use the following code: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }
}

# Create a Cognito User Identity Provider resource.
resource "aws_cognito_identity_provider" "example_provider" {
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email openid profile"
    client_id        = var.OAuth_client_id
    client_secret    = var.OAuth_client_secret
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}


# Create a cognito user pool client which generates authentication tokens to authorize a user for an application.
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                         = var.app_client_name
  explicit_auth_flows          = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  user_pool_id = aws_cognito_user_pool.user_pool.id
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.logout_url]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = [aws_cognito_identity_provider.example_provider.provider_name]
}

## Create a Cognito User Pool Domain resource.
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf33_googleIdp_cognito/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}