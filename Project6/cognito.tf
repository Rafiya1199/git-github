# Create a cognito user pool with username, password, email and name
resource "aws_cognito_user_pool" "royal_user_pool" {
  name = "royalUserPool"

  email_verification_subject = "Your Verification Code"
  email_verification_message = "Please use the following code: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

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

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 3
      max_length = 256
    }
  }
}

# Create a cognito user pool client which generates authentication tokens to authorize a user for an application.
resource "aws_cognito_user_pool_client" "royal_user_pool_client" {
  name                         = "royalUserPoolClient"
  explicit_auth_flows          = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  user_pool_id = aws_cognito_user_pool.royal_user_pool.id
}

# Get the user pool ID and client ID
output "royal_user_pool_id" {
  value = aws_cognito_user_pool.royal_user_pool.id
}

output "royal_user_pool_client_id" {
  value = aws_cognito_user_pool_client.royal_user_pool_client.id
}
