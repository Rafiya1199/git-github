# Get the user pool ID and client ID
output "User_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "App_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

#Get the Identity provider name
output "Identity_provider_name" {
  value = aws_cognito_identity_provider.example_provider.provider_name
}

#Get the Identity provider scopes
output "Identity_provider_scopes" {
  value = aws_cognito_identity_provider.example_provider.provider_details.authorize_scopes
}

#Get the cognito domain prefix
output "cognito_domain" {
  value = "https://${var.domain_prefix}.auth.${var.aws_region}.amazoncognito.com"
}

#Get the login endpoint URL
output "login_endpoint_url" {
  value = "https://${var.domain_prefix}.auth.${var.aws_region}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.user_pool_client.id}&redirect_uri=${var.callback_url}"
}