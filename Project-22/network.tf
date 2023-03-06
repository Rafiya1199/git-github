## Create Public subnet
resource "aws_subnet" "public_subnet1" {
    vpc_id     = var.default_vpc_id
    cidr_block = "172.31.3.0/24"
    availability_zone = "us-east-1a"
}

## Create EC2 security group
resource "aws_security_group" "ec2_sg" {
    name        = "EC2-security-group"
    vpc_id      = var.default_vpc_id
    
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]   
    }
 }