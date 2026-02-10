# AWS S3 Bucket Resource
# Creates and manages an S3 bucket with optional encryption, versioning, and folder structure

# Look up existing KMS key by alias if provided
data "aws_kms_alias" "this" {
  count = var.s3_config.kms_key_alias != null ? 1 : 0
  name  = "alias/${var.s3_config.kms_key_alias}"
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_config.bucket_name

  tags = {
    Name = var.s3_config.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.s3_config.versioning ? "Enabled" : "Suspended"
  }
}

# Server-side encryption configuration (SSE-S3 or SSE-KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.s3_config.sse_algorithm != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.s3_config.sse_algorithm
      kms_master_key_id = var.s3_config.sse_algorithm == "aws:kms" ? data.aws_kms_alias.this[0].target_key_id : null
    }
    bucket_key_enabled = var.s3_config.sse_algorithm == "aws:kms" ? true : null
  }
}

# Create folder placeholders (empty objects with trailing slash)
resource "aws_s3_object" "folders" {
  for_each = toset(var.s3_config.bucket_keys)

  bucket = aws_s3_bucket.this.id
  key    = "${each.value}/"
  source = "/dev/null"
}
