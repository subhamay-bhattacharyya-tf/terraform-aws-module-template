# Terratest

This directory contains [Terratest](https://terratest.gruntwork.io/) tests for the Terraform module.

## Prerequisites

- [Go](https://golang.org/dl/) >= 1.21
- [Terraform](https://www.terraform.io/downloads) >= 1.5.0
- AWS credentials configured (via environment variables or AWS CLI)

## Setup

```bash
cd test/terratest
go mod download
```

## Running Tests

### Run all tests

```bash
go test -v -timeout 30m
```

### Run a specific test

```bash
go test -v -timeout 30m -run TestBasicExample
```

### Run validation only (no AWS resources created)

```bash
go test -v -run TestModuleValidation
```

### Run plan only (no AWS resources created)

```bash
go test -v -run TestPlanNoChanges
```

## Test Descriptions

| Test | Description | Creates Resources |
|------|-------------|-------------------|
| `TestBasicExample` | Full integration test - init, apply, validate outputs, destroy | Yes |
| `TestModuleValidation` | Validates Terraform syntax and configuration | No |
| `TestPlanNoChanges` | Runs terraform plan to check for errors | No |

## Writing New Tests

1. Create a new test function in `module_test.go` or a new `*_test.go` file
2. Use `t.Parallel()` for concurrent test execution
3. Always use `defer terraform.Destroy()` to clean up resources
4. Use `terraform.WithDefaultRetryableErrors()` for resilience against transient AWS errors

## Tips

- Set `SKIP_destroy=true` to keep resources after test (useful for debugging)
- Use `-timeout` flag for tests that create AWS resources (default 10m may be too short)
- Run validation tests in CI on every PR, integration tests on merge to main
