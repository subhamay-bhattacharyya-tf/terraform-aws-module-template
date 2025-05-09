# Terraform AWS Module Template Repository

![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/f0fdfc35f6b51daa3b0ea2cd1b0dec23/raw/terraform-aws-module-template.json?)

# terraform-aws-s3-bucket

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