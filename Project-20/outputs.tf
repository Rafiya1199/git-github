output "ec2_instances_id" {
     value = aws_instance.ec2_instance.id
}

output "efs_id" {
     value = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
     value = aws_efs_file_system.efs.dns_name
}
