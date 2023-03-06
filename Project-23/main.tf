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

#create S3 bucket
resource "aws_s3_bucket" "example" {
    bucket = var.bucket_name 
    tags = var.tags   
}

resource "aws_s3_bucket_acl" "example" {
   bucket = aws_s3_bucket.example.id
   acl    = "private"
}

## Create an Amazon SQS queue and to allow Amazon S3 to send messages to the queue, add the required policy to the SQS queue. 
## The policy should allow the S3 bucket to send ObjectCreated event notifications to the specified SQS queue.
resource "aws_sqs_queue" "q" {
  name = "s3-event-queue"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3-event-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.example.arn}" }
      }
    }
  ]
}
POLICY
}

## Create an S3 event to send a notification to the SQS queue when an object is uploaded to the bucket.
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.example.id

  queue {
    queue_arn     = aws_sqs_queue.q.arn
    events        = ["s3:ObjectCreated:*"]
  }
}
 
# resource "null_resource" "example1" {
#    provisioner "local-exec" {
#      command = "aws s3 cp index.html s3://${var.bucket_name}"
# 	  }
# }

# resource "null_resource" "object2" {
#    provisioner "local-exec" {
#      command = "aws s3 cp error.html s3://${var.bucket_name}"
# 	  }
# }

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf42_s3_with_sqs/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}