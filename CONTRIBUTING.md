# Contributing

First off, thank you for considering contributing to this project! We're excited to have you on board.

## How Can I Help?

There are many ways you can help:

- Reporting bugs
- Suggesting features
- Improving documentation
- Adding or updating examples
- Submitting pull requests (PRs)

## Reporting Issues

If you find a bug or have an issue, please check the [open issues](../../issues) before creating a new one. If it's not there, feel free to open a new issue and provide as much information as possible.

## Development Setup

1. Install Terraform (`>= 1.5`), AWS CLI, and the following tools:
   - [tflint](https://github.com/terraform-linters/tflint)
   - [tfsec](https://github.com/aquasecurity/tfsec) (or checkov)
   - [terraform-docs](https://terraform-docs.io/)
   - [pre-commit](https://pre-commit.com/)

2. Set up pre-commit hooks:
   ```bash
   pre-commit install
   ```

3. Run formatting and validation:
   ```bash
   ./scripts/fmt.sh
   ./scripts/validate.sh
   ./scripts/lint.sh
   ./scripts/security-scan.sh
   ```

## Submitting Changes

1. Fork the repo
2. Create a branch for your feature (`git checkout -b feature-name`)
3. Make your changes
4. Run validation scripts to ensure quality
5. Commit using [Conventional Commits](https://www.conventionalcommits.org/) format
6. Push to your forked repo (`git push origin feature-name`)
7. Open a pull request to the main repository

## Pull Request Guidelines

- Keep PRs small and focused
- Add/update examples in `examples/` when behavior changes
- Update docs (`terraform-docs`) if inputs/outputs change
- Ensure all validation scripts pass

## Commit Messages

This repo uses Conventional Commits + Semantic Release. Use these formats:

- `feat: add support for encryption` — new feature (minor version)
- `fix: correct IAM policy` — bug fix (patch version)
- `docs: update README` — documentation only
- `chore: update dependencies` — maintenance
- `feat!: change output format` — breaking change (major version)

---

Thanks for contributing! You're awesome. 😎
