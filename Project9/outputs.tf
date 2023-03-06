output "email_identity_arn" {
  description = "The ARN of the email identity."
  value       = aws_ses_email_identity.email_id.arn
}

output "Lambda_Function_name" {
  description = "Lambda function name"
  value = aws_lambda_function.tf_lambda_func.function_name
}

output "api_name" {
  description = "REST API name"
  value = aws_api_gateway_rest_api.restful_api.name
}
# Get the API endpoint URL
output "api_endpoint_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_stage.example.stage_name}/sendContactEmail"
}

 # Get custom domain1 url
output "custom_domain1_url" {
  description = "Custom Domain url"
  value = "https://${aws_api_gateway_domain_name.example.domain_name}/sendContactEmail"
 }

# Get custom domain2 url
output "custom_domain2_url" {
  description = "Custom Domain2 url"
  value = "https://${aws_api_gateway_domain_name.example2.domain_name}/sendContactEmail"
 }

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