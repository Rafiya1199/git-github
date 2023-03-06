variable "aws_region" {
  type     = string
  default  = "us-east-1"
}

variable "default_vpc_id" {
     type     = string
     default  = "vpc-023bddfc27702b2e9"
}

variable "default_subnet_id" {
     type     = string
     default  = "subnet-0215ce3d092efed36"
}

variable "instance_type" {
    description = "ec2_instance_type"
    type        = string
    default     = "t2.micro"   
}
 
variable "ami_id" {
    description = "AMI ID to use for the instance"
    type        = string
    default     = "ami-0b5eea76982371e91"    #us-east-1
}
  
variable "iam_instance_profile" {
    description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
    type        = string
    default     = "ec2_SSM_role"
}