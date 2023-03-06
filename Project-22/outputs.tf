output "ec2_instances_id" {
      value = aws_instance.ec2_instance.id
}

output "ec2_instances_arn" {
      value = aws_instance.ec2_instance.arn
}

output "Cloudwatch_alarm_name" {
      value = aws_cloudwatch_metric_alarm.my_ec2_alarm.metric_name
}

output "Cloudwatch_alarm_arn" {
      value = aws_cloudwatch_metric_alarm.my_ec2_alarm.arn
}

output "Cloudwatch_alarm_id" {
      value = aws_cloudwatch_metric_alarm.my_ec2_alarm.id
}


