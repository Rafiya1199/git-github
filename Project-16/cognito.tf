# Create a cognito user pool
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

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
}

##Create a user in the user pool
resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = var.user_name
  password     = var.user_password
}

## Create a Cognito User Pool Domain resource.
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

# Create a cognito user pool client which generates authentication tokens to authorize a user for an application.
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                         = var.app_client_name
  explicit_auth_flows          = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  user_pool_id = aws_cognito_user_pool.user_pool.id
  # callback_urls                = ["https://example.com/signin"]
  # logout_urls                  = ["https://example.com/signout"]
  # allowed_oauth_flows          = ["implicit"]
  generate_secret              = true
  allowed_oauth_flows          = ["client_credentials"]
  supported_identity_providers = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = "${ aws_cognito_resource_server.resource_server.scope_identifiers }"

  depends_on = [
    aws_cognito_user_pool.user_pool,
    aws_cognito_resource_server.resource_server,
  ]
}

# Create a resource server with sample-scope
resource "aws_cognito_resource_server" "resource_server" {
  identifier = "https://example.com"
  name       = "example"

  scope {
    scope_name        = "read"
    scope_description = "a Sample Scope"
  }

  user_pool_id = aws_cognito_user_pool.user_pool.id
}