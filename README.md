# terraform-aws-module-template

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-module-template/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-FF9900?&logo=amazon-aws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-module-template)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/d33af43445164c377f9dec82c846dbce/raw/terraform-aws-module-template.json?)

A production-ready template for creating reusable Terraform modules for AWS. Use this as a starting point for your own modules with built-in CI/CD, documentation generation, security scanning, and semantic versioning.

## Features

- Opinionated project structure following Terraform best practices
- Pre-configured CI/CD with GitHub Actions
- Semantic Release for automated versioning and changelog generation
- Security scanning with Trivy
- Linting with tflint
- Auto-generated documentation with terraform-docs
- Pre-commit hooks for consistent code quality
- Example configurations (basic and complete)
- Terratest integration for testing
- Dev Container support for consistent development environments
- Submodule support

## Repository Structure

```
.
├── .devcontainer/         # Dev Container configuration
├── .github/
│   ├── ISSUE_TEMPLATE/    # Issue templates
│   └── workflows/         # CI/CD pipelines
├── docs/                  # Architecture docs and ADRs
├── examples/
│   ├── basic/             # Minimal usage example
│   └── complete/          # Full-featured example
├── modules/               # Submodules
├── scripts/               # Helper scripts (fmt, lint, validate, etc.)
├── test/
│   └── terratest/         # Go-based infrastructure tests
├── main.tf                # Main module resources
├── variables.tf           # Input variables
├── outputs.tf             # Output values
└── versions.tf            # Provider and Terraform version constraints
```

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.14.0 |
| AWS Provider | >= 5.0 |

## Usage

```hcl
module "example" {
  source  = "github.com/subhamay-bhattacharyya-tf-tf/terraform-aws-module-template"
  # version = "x.y.z"  # Pin to a specific version in production

  name = "my-resource"
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

## Examples

- [Basic](./examples/basic) - Minimal configuration
- [Complete](./examples/complete) - Full configuration with all options

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the primary resource created by this module | `string` | n/a | yes |
| tags | Tags to apply to all taggable resources | `map(string)` | `{}` | no |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for the primary resource created by this module. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all taggable resources. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Outputs

| Name | Description |
|------|-------------|
| id | Primary resource ID |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Getting Started

### Using This Template

1. Click "Use this template" on GitHub to create a new repository
2. Clone your new repository
3. Update `main.tf` with your resources
4. Update `variables.tf` and `outputs.tf` as needed
5. Add examples in `examples/`
6. Run validation:
   ```bash
   ./scripts/fmt.sh
   ./scripts/validate.sh
   ./scripts/lint.sh
   ./scripts/security-scan.sh
   ```

### Development Tools

Install the following tools for local development:

- [Terraform](https://www.terraform.io/downloads) >= 1.14.0
- [tflint](https://github.com/terraform-linters/tflint)
- [Trivy](https://github.com/aquasecurity/trivy)
- [terraform-docs](https://terraform-docs.io/)
- [pre-commit](https://pre-commit.com/)
- [Go](https://golang.org/) >= 1.21 (for Terratest)

### Dev Container

This repository includes a Dev Container configuration for VS Code / GitHub Codespaces:

```bash
# Open in VS Code with Dev Containers extension
code .
# Then: Ctrl+Shift+P → "Dev Containers: Reopen in Container"
```

### Pre-commit Hooks

```bash
pre-commit install
pre-commit run --all-files
```

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/fmt.sh` | Format Terraform files |
| `scripts/validate.sh` | Validate Terraform configuration |
| `scripts/lint.sh` | Run tflint |
| `scripts/security-scan.sh` | Run security scan |
| `scripts/docs.sh` | Generate documentation |

## Testing

This module uses [Terratest](https://terratest.gruntwork.io/) for infrastructure testing.

```bash
cd test/terratest
go mod download
go test -v -run TestModuleValidation -timeout 10m
```

See [test/terratest/README.md](./test/terratest/README.md) for more details.

## Versioning

This project uses [Semantic Release](https://semantic-release.gitbook.io/) with [Conventional Commits](https://www.conventionalcommits.org/).

Commit message examples:
- `feat: add support for encryption` → Minor version bump
- `fix: correct IAM policy` → Patch version bump
- `feat!: change output format` → Major version bump (breaking change)

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines.

## Security

See [SECURITY.md](./SECURITY.md) for reporting vulnerabilities.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Author

Subhamay Bhattacharyya
