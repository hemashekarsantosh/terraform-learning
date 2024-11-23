output "s3_bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "name" {
  value = aws_s3_bucket.s3_bucket.bucket
}