output "bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "versioning_enabled" {
  description = "Whether versioning is enabled."
  value       = var.s3_config.versioning
}

output "bucket_keys" {
  description = "The bucket keys created in the bucket."
  value       = [for k, v in aws_s3_object.bucket_keys : v.key]
}
