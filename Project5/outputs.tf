output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.private_subnets
}

# Get the user pool ID and client ID
output "royal_user_pool_id" {
  value = aws_cognito_user_pool.royal_user_pool.id
}

output "royal_user_pool_client_id" {
  value = aws_cognito_user_pool_client.royal_user_pool_client.id
}

# Get the base URL for the API
output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "Lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "api_vpc_endpoint_ID" {
  value = aws_vpc_endpoint.vpc_endpoint.id
}
