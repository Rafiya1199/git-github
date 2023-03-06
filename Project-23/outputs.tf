output "s3_bucket_id" {
   description = "Name (id) of the bucket"
   value = aws_s3_bucket.example.id
}
 
output "s3_bucket_arn" {
   description = "ARN of the bucket"
   value       = aws_s3_bucket.example.arn
}

output "sqs_queue_name" {
   description = "Queue name"
   value = aws_sqs_queue.q.name
}

output "sqs_queue_arn" {
   description = "Queue arn"
   value = aws_sqs_queue.q.arn
}

output "sqs_queue_id" {
   description = "Queue id"
   value = aws_sqs_queue.q.id
}
 