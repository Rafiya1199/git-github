## Security group for ec2 instances. Traffic to the instances should only come from the ALB. 
resource "aws_security_group" "ec2_sg" {
   name        = "EC2-security-group"
   vpc_id      = var.default_vpc_id
 
   ingress {
     protocol    = "tcp"
     from_port   = 80
     to_port     = 80
	   security_groups = [aws_security_group.lb_sg.id]
   }
 
   egress {
     protocol    = "-1"
     from_port   = 0
     to_port     = 0
     cidr_blocks = ["0.0.0.0/0"]
   }
}

## User data for ec2 instances
data "template_file" "init" {
template = "${file("${path.module}/scripts/script.sh")}"
}

# To iterate over the map object with EC2 instances, use the for_each function.
## use the machine_type attribute for instance type.
## subnet_id is where to create the instance.
resource "aws_instance" "ec2_instances" {
  for_each = local.web_servers

  ami           = var.ami_id
  instance_type = each.value.machine_type
  subnet_id     = each.value.subnet_id
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
     Name = "tcf38 Web server"
   }
  user_data = "${data.template_file.init.rendered}"
}
