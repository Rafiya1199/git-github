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

## Create a Elastic File System (EFS) resource.
##creation_token - unique name for efs
##performance_mode - Can be either "generalPurpose" or "maxIO"
##throughput_mode - Valid values: bursting, provisioned, or elastic
##encrypted - (Optional) If true, the disk will be encrypted.
resource "aws_efs_file_system" "efs" {

   creation_token = "efs"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "EFS"
   }
 }

## Create (EFS) mount target.
## A mount target provides an IP address for an NFSv4 endpoint at which you can mount an Amazon EFS file system. 
resource "aws_efs_mount_target" "efs-mt" {
   
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = var.default_subnet_id
   security_groups = [aws_security_group.efs.id]
}

#  ## User data for ec2 instance
#  data "template_file" "init" {
#  template = "${file("${path.module}/scripts/script.sh")}"
#  }

resource "aws_instance" "ec2_instance" {
    depends_on = [
    aws_efs_file_system.efs, aws_efs_mount_target.efs-mt,
    ]
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.default_subnet_id
    associate_public_ip_address= true
    iam_instance_profile = var.iam_instance_profile
    key_name="my-ec2-key-pair" 
    vpc_security_group_ids = [ aws_security_group.ec2.id ]
    tags= {
        Name = "testinstance"
    }
    # user_data = "${data.template_file.init.rendered}"
    lifecycle {
        create_before_destroy = true
    }
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf39_ec2_with_efs/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}