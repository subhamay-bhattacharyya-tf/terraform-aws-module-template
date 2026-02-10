# Terraform AWS S3 Bucket Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-s3-bucket)

A Terraform module for creating and managing AWS S3 buckets with optional encryption (SSE-S3 or SSE-KMS), versioning, folder structure, and bucket policy.

## Features

- JSON-style configuration input
- Server-side encryption with SSE-S3 (AES256) or SSE-KMS
- Configurable versioning
- Automatic folder/prefix creation
- Public access blocked by default
- Optional bucket policy
- Built-in input validation

## Usage

### Basic S3 Bucket

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name = "my-bucket"
  }
}
```

### S3 Bucket with Versioning

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name = "my-versioned-bucket"
    versioning  = true
  }
}
```

### S3 Bucket with SSE-S3 Encryption

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name   = "my-encrypted-bucket"
    sse_algorithm = "AES256"
  }
}
```

### S3 Bucket with SSE-KMS Encryption

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name   = "my-kms-bucket"
    sse_algorithm = "aws:kms"
    kms_key_alias = "my-kms-key"
  }
}
```

### S3 Bucket with Folders

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name = "my-data-bucket"
    bucket_keys = ["raw-data/csv", "raw-data/json", "processed"]
  }
}
```

### S3 Bucket with Bucket Policy

```hcl
module "s3_bucket" {
  source = "path/to/modules/aws-s3-bucket"

  s3_config = {
    bucket_name   = "my-policy-bucket"
    bucket_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "AllowSSLRequestsOnly"
          Effect    = "Deny"
          Principal = "*"
          Action    = "s3:*"
          Resource = [
            "arn:aws:s3:::my-policy-bucket",
            "arn:aws:s3:::my-policy-bucket/*"
          ]
          Condition = {
            Bool = {
              "aws:SecureTransport" = "false"
            }
          }
        }
      ]
    })
  }
}
```

### Using JSON Input

```bash
terraform apply -var='region=us-east-1' -var='s3={"bucket_name":"my-bucket","bucket_keys":["raw-data/csv","raw-data/json"],"versioning":true,"sse_algorithm":"aws:kms","kms_key_alias":"SB-KMS"}'
```

## Examples

| Example | Description |
|---------|-------------|
| [basic](examples/basic) | Simple S3 bucket |
| [versioning](examples/versioning) | S3 bucket with versioning enabled |
| [sse-s3](examples/sse-s3) | S3 bucket with SSE-S3 encryption |
| [sse-kms](examples/sse-kms) | S3 bucket with SSE-KMS encryption |
| [with-folders](examples/with-folders) | S3 bucket with folder structure |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| s3_config | Configuration object for S3 bucket | `object` | - | yes |

### s3_config Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| bucket_name | string | - | Name of the S3 bucket (required) |
| bucket_keys | list(string) | [] | List of folder prefixes to create |
| versioning | bool | false | Enable versioning on the bucket |
| sse_algorithm | string | null | Encryption algorithm: `AES256` (SSE-S3) or `aws:kms` (SSE-KMS) |
| kms_key_alias | string | null | KMS key alias (required when sse_algorithm is `aws:kms`) |
| bucket_policy | string | null | JSON bucket policy document |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket domain name |
| versioning_enabled | Whether versioning is enabled |
| folder_keys | The folder keys created in the bucket |

## Resources Created

| Resource | Description |
|----------|-------------|
| aws_s3_bucket | The S3 bucket |
| aws_s3_bucket_versioning | Versioning configuration |
| aws_s3_bucket_public_access_block | Blocks all public access |
| aws_s3_bucket_server_side_encryption_configuration | Encryption configuration (conditional) |
| aws_s3_bucket_policy | Bucket policy (conditional) |
| aws_s3_object | Folder placeholders (conditional) |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty bucket name
- Bucket name exceeding 63 characters
- Invalid sse_algorithm value
- Missing kms_key_alias when using SSE-KMS

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

### Test Cases

| Test | Description |
|------|-------------|
| TestS3BucketBasic | Basic bucket creation |
| TestS3BucketVersioning | Bucket with versioning |
| TestS3BucketSSES3 | Bucket with SSE-S3 encryption |
| TestS3BucketSSEKMS | Bucket with SSE-KMS encryption |
| TestS3BucketWithFolders | Bucket with folder structure |

AWS credentials must be configured via environment variables or AWS CLI profile.

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**` changes)
- Pull requests to `main` (when `modules/**` changes)
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests
- Changelog generation (non-main branches)
- Semantic release (main branch only)

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |

### GitHub Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |

## License

MIT License - See [LICENSE](LICENSE) for details.
