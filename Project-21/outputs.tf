output "s3_bucket_id" {
  description = "Name (id) of the bucket"
  value = aws_s3_bucket.example.id
}

output "s3_bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.example.arn
}

output "s3_domain" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket_website_configuration.example.website_domain
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.example.website_endpoint
}

output "cloudfront_id" {
  description = "ID of the cloudfront distribution"
  value       = aws_cloudfront_distribution.prod_distribution.id
}

output "cloudfront_arn" {
  description = "ARN of the cloudfront distribution"
  value       = aws_cloudfront_distribution.prod_distribution.arn
}

output "cloudfront_domain" {
  description = "Domain name of cloudfront distribution"
  value       = aws_cloudfront_distribution.prod_distribution.domain_name
}
