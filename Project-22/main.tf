terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

##Create an ec2 instance
resource "aws_instance" "ec2_instance" {
    
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public_subnet1.id
    associate_public_ip_address= true
    iam_instance_profile = var.iam_instance_profile
    vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
     
    lifecycle {
         create_before_destroy = true
    }
    tags= {
        Name = "tcf41_test_server"
    }
}

## Create a CloudWatch Metric Alarm for EC2 CPU utilization
##comparison_operator - The arithmetic operation to use when comparing the specified Statistic and Threshold.
##evaluation_periods - The number of periods over which data is compared to the specified threshold.
## period - The period in seconds over which the specified statistic is applied. 
## statistic - The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum
## threshold - The value against which the specified statistic is compared. 
## alarm_actions - The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN).
## dimensions -  The dimensions for the alarm's associated metric. 
resource "aws_cloudwatch_metric_alarm" "my_ec2_alarm" {
    
    alarm_name                = "ec2_cpuUtilization_alarm"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = "2"
    metric_name               = "CPUUtilization"
    namespace                 = "AWS/EC2"
    period                    = "120" #seconds
    statistic                 = "Average"
    threshold                 = "40"
    alarm_description         = "Terminate the EC2 instance when CPU utilization reaches 40% on average for 2 periods of 2 minutes, i.e. 4 minutes"
    alarm_actions             = ["arn:aws:automate:${var.aws_region}:ec2:terminate"]

    dimensions = {
        InstanceId = "${aws_instance.ec2_instance.id}"
    }
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf41_ec2_cloudwatch_alarm/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}