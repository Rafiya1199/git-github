# Get the user pool ID and client ID
output "User_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "App_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

# Get the user name in Cognito user pool
output "User_name" {
  value = aws_cognito_user.user.username
}

# Get the custom scopes 
output "custom_scopes" {
  value = aws_cognito_resource_server.resource_server.scope_identifiers
}

# Get the API name
output "api_name" {
  value = aws_api_gateway_rest_api.api.name
}

# Get the base URL for the API
output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

# Get Lambda function names for the API endpoints
output "Lambda_function_name1" {
  value = aws_lambda_function.lambda_fn_1.function_name
}

output "Lambda_function_name2" {
  value = aws_lambda_function.lambda_fn_2.function_name
}