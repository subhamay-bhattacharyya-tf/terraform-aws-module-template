# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < Latest | :x:               |

Only the latest major/minor release receives security updates. We recommend always using the most recent version.

## Reporting a Vulnerability

Please do **not** open public issues for security vulnerabilities.

### Preferred Method

Use [GitHub Security Advisories](../../security/advisories/new) to report vulnerabilities privately. This allows us to assess the issue, work on a fix, and coordinate disclosure.

### Alternative Contact

If you're unable to use GitHub Security Advisories, contact the maintainers directly via email at: `security@example.com` (replace with your actual contact).

### What to Include

When reporting a vulnerability, please provide:

- Description of the vulnerability
- Steps to reproduce or proof of concept
- Affected versions
- Potential impact
- Any suggested fixes (optional)

## Response Timeline

- **Initial Response:** Within 48 hours of report submission
- **Status Update:** Within 7 days with assessment and remediation plan
- **Fix Release:** Typically within 30 days, depending on severity and complexity

## Disclosure Policy

- We follow coordinated disclosure practices
- We aim to release fixes within 90 days of confirmed vulnerabilities
- Credit will be given to reporters unless anonymity is requested
- We will notify you before any public disclosure

## Scope

The following are considered security issues:

- Vulnerabilities in the Terraform module code
- Misconfigurations that could lead to insecure AWS resources
- Sensitive data exposure in outputs or logs
- Supply chain issues (compromised dependencies)

The following are **not** security issues:

- General bugs or feature requests
- Issues in upstream providers (report to HashiCorp/AWS)
- User misconfiguration of module inputs

## Security Best Practices

When using this module:

- Always pin to a specific version in production
- Review the module code before deployment
- Use Terraform state encryption
- Follow AWS security best practices for IAM and resource policies
