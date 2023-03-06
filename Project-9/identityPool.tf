#Create a AWS Cognito Identity Pool
resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.user_pool_client.id
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
    server_side_token_check = false
  }
}

## Attach a role in identity pool for authenticated users
## Configure the identity pool to use "Choose role from token" option under Authenticated role selection. This will override the default 
## authenticated role for the identity pool, and instead use the IAM role associated with the user's Cognito user pool group.
## And set the role_resolution to "Deny" or "AuthenticatedRole"
resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id

  role_mapping {
    identity_provider         = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}:${aws_cognito_user_pool_client.user_pool_client.id}"
    ambiguous_role_resolution = "Deny"
    type                      = "Token"

  }
    roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}