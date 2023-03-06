output "Lambda_Function_name" {
  value = aws_lambda_function.tf_lambda_func.function_name
}

output "aws_cloudwatch_event_rule_name" {
  value = aws_cloudwatch_event_rule.CW_rule.name
}

output "ec2_instance_id" {
  description = "The ID of the instance"
  value       = module.ec2_instances[0].id
}

output "ec2_instance_arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instances[0].arn
}
