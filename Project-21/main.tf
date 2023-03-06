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


#create S3 bucket
resource "aws_s3_bucket" "example" {  
  bucket = var.bucket_name 
  tags = var.tags   
}

locals {
  s3_origin_id = "myS3Origin"
  s3_domain = "${aws_s3_bucket.example.id}.s3.${var.aws_region}.amazonaws.com"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"

}

resource "aws_s3_object" "object_www" {
  depends_on   = [aws_s3_bucket.example]
  for_each     = fileset("${path.root}", "www/*.html")
  bucket       = var.bucket_name
  key          = basename(each.value)
  source       = each.value
  etag         = filemd5("${each.value}")
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#setup dynamo DB as our locking mechanism with s3 remote backend
terraform {
  backend "s3" {
    bucket = "tcf-tf-statefiles"
    key    = "dev/tcf40_cloudfront_s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcf-tf-statefiles-lock"
  }
}