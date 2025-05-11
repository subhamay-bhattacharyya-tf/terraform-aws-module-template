# Terraform AWS Module Template Repository

![CI](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-module-template/actions/workflows/ci.yml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/f0fdfc35f6b51daa3b0ea2cd1b0dec23/raw/terraform-aws-module-template.json?)

## terraform-aws-s3-bucket

## 🚀 Terraform Module to Create AWS S3 Buckets

This module creates and manages AWS S3 buckets with configurable settings such as versioning, encryption, lifecycle policies, access logging, public access blocking, and more. It supports loading configuration from a JSON file and includes input validation for enhanced reliability.

---

## 📦 Features

- Create S3 bucket with customizable name and tags
- Enable server-side encryption (SSE-S3, SSE-KMS)
- Enable bucket versioning
- Configure lifecycle rules (transitions, expiration)
- Enable access logging
- Block public access settings
- Policy attachment (optional)
- JSON-driven configuration support
- Pre-commit hooks for code quality

---

## 🛠 Usage

```hcl
module "s3_bucket" {
  source = "github.com/<your-org>/terraform-aws-s3-bucket"

  s3_config_path = "${path.module}/s3_configuration.json"
}
```

### Sample `s3_configuration.json`

```json
{
  "bucket-base-name": "my-app-data",
  "tags": {
    "Project": "myapp",
    "Environment": "devl"
  },
  "encryption": {
    "enabled": true,
    "type": "SSE-KMS",
    "key_arn": "arn:aws:kms:us-east-1:123456789012:key/abcd..."
  },
  "versioning": true,
  "lifecycle_rules": [
    {
      "id": "log-cleanup",
      "enabled": true,
      "prefix": "logs/",
      "transition": [
        {
          "days": 30,
          "storage_class": "STANDARD_IA"
        }
      ],
      "expiration": {
        "days": 365
      }
    }
  ]
}
```

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.intelligent_tiering_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.s3_bucket_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_sse_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [null_resource.validate_access_logging](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_bucket_name](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_bucket_versioning](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_encryption_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_environment_name](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_intelligent_tiering](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_lifecycle_rules](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validate_project_name](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_json_file"></a> [config\_json\_file](#input\_config\_json\_file) | Path to the JSON configuration file for S3 bucket creation. | `string` | `"s3-configuration.json"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_encryption_configuration"></a> [s3\_bucket\_encryption\_configuration](#output\_s3\_bucket\_encryption\_configuration) | The encryption configuration of the S3 bucket. |
| <a name="output_s3_bucket_intelligent_tiering_configuration"></a> [s3\_bucket\_intelligent\_tiering\_configuration](#output\_s3\_bucket\_intelligent\_tiering\_configuration) | The intelligent tiering configuration of the S3 bucket. |
| <a name="output_s3_bucket_logging_configuration"></a> [s3\_bucket\_logging\_configuration](#output\_s3\_bucket\_logging\_configuration) | The logging configuration of the S3 bucket. |
| <a name="output_s3_bucket_logging_id"></a> [s3\_bucket\_logging\_id](#output\_s3\_bucket\_logging\_id) | The ID of the logging configuration. |
| <a name="output_s3_bucket_logging_target_bucket"></a> [s3\_bucket\_logging\_target\_bucket](#output\_s3\_bucket\_logging\_target\_bucket) | The target bucket for logging. |
| <a name="output_s3_bucket_logging_target_prefix"></a> [s3\_bucket\_logging\_target\_prefix](#output\_s3\_bucket\_logging\_target\_prefix) | The target prefix for logging. |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the S3 bucket created. |
| <a name="output_s3_bucket_versioning"></a> [s3\_bucket\_versioning](#output\_s3\_bucket\_versioning) | The versioning configuration of the S3 bucket. |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Subhamay Bhattacharyya](https://github.com/subhamay-bhattacharyya)

### 🤝 Contributing

Contributions are welcome! Please follow standard GitHub PR practices:

1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request
5. Please include tests and documentation for any new features.

## License

MIT
