terraform {
   required_providers {
     aws = {
       source = "hashicorp/aws"
       version = "4.53.0"
     }
   }
	 }
 
provider "aws" {
      region = var.aws_region
}

## use the machine_type specifies instance type.
## subnet_id defines where to create the instance. Use different subnet id to spread them between two different AZs.
locals {
  web_servers = {
    instance-01 = {
      machine_type = var.instance_type
      subnet_id    = var.public_subnet1_id
    }
    instance-02 = {
      machine_type = var.instance_type
      subnet_id    = var.public_subnet2_id
    }
  }
}
 
# ALB Security Group
resource "aws_security_group" "lb_sg" {
    name        = "tcf38-ALB-sg"
    description = "tcf38-ALB-sg"
    vpc_id      = var.default_vpc_id
  
    ingress {
      protocol    = "tcp"
 	     from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
   }
}

#Create an ALB 
resource "aws_lb" "test" {
    name               = "tcf38-ALB"
    internal           = false
    load_balancer_type = "application"
    ip_address_type    = "ipv4"
    security_groups    = [aws_security_group.lb_sg.id]
    subnets            = [var.public_subnet1_id, var.public_subnet2_id]
}
  
## Create a target group of target_type = "instance".
resource "aws_lb_target_group" "alb-example" {
    name_prefix = "tf-TG"
    target_type = "instance"
    port     = 80
    protocol = "HTTP"
    vpc_id      = var.default_vpc_id
    protocol_version = "HTTP1"
    lifecycle {
      create_before_destroy = true
    }
}

## Create a listener which checks for connection requests. 
resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.test.arn
    port              = "80"
    protocol          = "HTTP"
  
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.alb-example.arn
    }
}
 
# Register EC2 instances to the target group, 
# you need to iterate over each instance and attach it to the group using the traffic 80 port.
resource "aws_lb_target_group_attachment" "ec2_tg" {
  for_each = aws_instance.ec2_instances

  target_group_arn = aws_lb_target_group.alb-example.arn
  target_id        = each.value.id
  port             = 80
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
   backend "s3" {
     bucket = "tcf-tf-statefiles"
     key    = "dev/tcf38_alb_with_ec2/terraform.tfstate"
     region = "us-east-1"
     dynamodb_table = "tcf-tf-statefiles-lock"
   }
 }