output "email_identity_arn" {
  description = "The ARN of the email identity."
  value       = aws_ses_email_identity.email_id.arn
}

output "Lambda_Function_name" {
  description = "Lambda function name"
  value = aws_lambda_function.tf_lambda_func.function_name
}

output "api_name" {
  description = "HTTP API name"
  value = aws_apigatewayv2_api.lambda.name
}
# Get the API endpoint URL
output "api_endpoint_url" {
  value = "${aws_apigatewayv2_stage.default.invoke_url}/sendContactEmail"
}
