output "bucket_id" {
  description = "The name of the bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.s3_bucket.bucket_arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3_bucket.bucket_domain_name
}

output "bucket_keys" {
  description = "The folder keys created in the bucket"
  value       = module.s3_bucket.bucket_keys
}
