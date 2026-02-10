// File: test/s3_bucket_test.go
package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestS3BucketBasic tests creating a basic S3 bucket
func TestS3BucketBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-basic-%s", unique)

	tfDir := "../examples/basic"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	outputBucketID := terraform.Output(t, tfOptions, "bucket_id")
	require.Equal(t, bucketName, outputBucketID)
}

// TestS3BucketVersioning tests creating an S3 bucket with versioning enabled
func TestS3BucketVersioning(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-versioning-%s", unique)

	tfDir := "../examples/versioning"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
		"versioning":  true,
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	props := fetchBucketProps(t, client, bucketName)
	require.True(t, props.VersioningEnabled, "Expected versioning to be enabled")

	outputVersioning := terraform.Output(t, tfOptions, "versioning_enabled")
	require.Equal(t, "true", outputVersioning)
}

// TestS3BucketSSES3 tests creating an S3 bucket with SSE-S3 encryption
func TestS3BucketSSES3(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-sse-s3-%s", unique)

	tfDir := "../examples/sse-s3"

	s3Config := map[string]interface{}{
		"bucket_name":   bucketName,
		"sse_algorithm": "AES256",
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	props := fetchBucketProps(t, client, bucketName)
	require.Equal(t, "AES256", props.SSEAlgorithm, "Expected SSE-S3 encryption")
}

// TestS3BucketSSEKMS tests creating an S3 bucket with SSE-KMS encryption
func TestS3BucketSSEKMS(t *testing.T) {
	t.Parallel()

	kmsKeyAlias := "SB-KMS"

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-sse-kms-%s", unique)

	tfDir := "../examples/sse-kms"

	s3Config := map[string]interface{}{
		"bucket_name":   bucketName,
		"sse_algorithm": "aws:kms",
		"kms_key_alias": kmsKeyAlias,
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	props := fetchBucketProps(t, client, bucketName)
	require.Equal(t, "aws:kms", props.SSEAlgorithm, "Expected SSE-KMS encryption")
	require.NotEmpty(t, props.KMSKeyID, "Expected KMS key ID to be set")
}

// TestS3BucketWithFolders tests creating an S3 bucket with folder structure
func TestS3BucketWithFolders(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-folders-%s", unique)

	tfDir := "../examples/with-folders"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
		"bucket_keys": []string{"raw-data/csv", "raw-data/json", "processed"},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	folders := listBucketObjects(t, client, bucketName)
	require.Contains(t, folders, "raw-data/csv/")
	require.Contains(t, folders, "raw-data/json/")
	require.Contains(t, folders, "processed/")
}
