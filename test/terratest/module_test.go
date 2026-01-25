package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestBasicExample tests the basic example configuration
func TestBasicExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Path to the Terraform code to test
		TerraformDir: "../../examples/basic",

		// Variables to pass to Terraform
		Vars: map[string]interface{}{
			"name": "terratest-basic",
			"tags": map[string]string{
				"Environment": "test",
				"ManagedBy":   "terratest",
			},
		},
	})

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs (uncomment when you have outputs defined)
	// output := terraform.Output(t, terraformOptions, "id")
	// assert.NotEmpty(t, output)
}

// TestModuleValidation validates the module without deploying resources
func TestModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/basic",
	}

	// Run "terraform init" and "terraform validate"
	terraform.Init(t, terraformOptions)
	result := terraform.Validate(t, terraformOptions)

	assert.True(t, result == "", "Terraform validation should pass")
}

// TestPlanNoChanges verifies the plan runs without errors
func TestPlanNoChanges(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/basic",
		Vars: map[string]interface{}{
			"name": "terratest-plan",
		},
	}

	// Run "terraform init" and "terraform plan"
	terraform.Init(t, terraformOptions)
	terraform.Plan(t, terraformOptions)
}
