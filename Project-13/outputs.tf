# Get the user pool ID and client ID
output "User_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "App_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

# Get the user1 name in Cognito user pool
output "User1_name" {
  value = aws_cognito_user.user1.username
}

# Get the user2 name in Cognito user pool
output "User2_name" {
  value = aws_cognito_user.user2.username
}

# Get the user1 group name in Cognito user pool
output "User1_group_name" {
  value = aws_cognito_user_group.group1.name
}

# Get the user2 group name in Cognito user pool
output "User2_group_name" {
  value = aws_cognito_user_group.group2.name
}

# Get the Identity pool ID
output "identity_Pool_id" {
  value = aws_cognito_identity_pool.main.id
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