output "alb_hostname" {
    value = aws_lb.test.dns_name
}
 
output "Web_alb_id" {
    value = aws_lb.test.id
}
 
output "target_group_name" {
    value = aws_lb_target_group.alb-example.name
}

output "ec2_instances_id" {
    value = values(aws_instance.ec2_instances)[*].id
}
