output "Lambda_Function_name" {
  value = aws_lambda_function.terraform_lambda_func.function_name
}

output "aws_lambda_layer_name" {
  value = aws_lambda_layer_version.lambda_layer.layer_name
}

output "aws_cloudwatch_event_rule_name" {
  value = aws_cloudwatch_event_rule.schedule.name
}
