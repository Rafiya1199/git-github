# ##Uncomment this file if you want to create a private api and call the api in a private subnet without internet access. 
# ##This file also creates an EC2 instance in private subnet that can be connected to ssm through ssm endpoints.
# ## If you want to use this file then comment out line #12-61 in main.tf file and line # 1-9 in outputs.tf

# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
# }
# #Create a subnet
# resource "aws_subnet" "private" {
#   cidr_block = "10.0.2.0/24"
#   vpc_id     = aws_vpc.main.id
# }

# #Create a interface vpc endpoint
# resource "aws_vpc_endpoint" "vpc_endpoint" {
#   service_name        = "com.amazonaws.us-east-1.execute-api"
#   vpc_id              = aws_vpc.main.id
#   subnet_ids          =  [aws_subnet.private.id]
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
# }

# #Create a security group that allows tcp inbound traffic from the VPC
# resource "aws_security_group" "vpc_endpoint_sg" {
#   vpc_id      = aws_vpc.main.id
#   name        = "api-vpc-endpoint-sg"
#   description = "Allow HTTPS inbound traffic"
#   ingress {
#     description = "HTTPS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.main.cidr_block]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create an EC2 instance to call the private api in private subnet
# module "ec2_instances" {
#   source  = "../ec2-session-manager"
#   count   = 1
  
#   name = "my-ec2-cluster"
#   associate_public_ip_address = false
#   iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#   subnet_id              = aws_subnet.private.id
#   vpc_security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
#   private_ip             = "10.0.2.120"

# }
# # Create 3 endpoints with the following services: com.amazonaws.[region].ssm, com.amazonaws.[region].ssmmessages, and com.amazonaws.[region].ec2messages
# # to connect to session manager 
# resource "aws_vpc_endpoint" "ssm_endpoint" {
#   service_name        = "com.amazonaws.us-east-1.ssm"
#   vpc_id              = aws_vpc.main.id
#   subnet_ids          =  [aws_subnet.private.id]
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "ssm_msgs_endpoint" {
#   service_name        = "com.amazonaws.us-east-1.ssmmessages"
#   vpc_id              = aws_vpc.main.id
#   subnet_ids          =  [aws_subnet.private.id]
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "ec2_msgs_endpoint" {
#   service_name        = "com.amazonaws.us-east-1.ec2messages"
#   vpc_id              = aws_vpc.main.id
#   subnet_ids          =  [aws_subnet.private.id]
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
# }
