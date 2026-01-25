# terraform-aws-module-template
# A reusable Terraform module for AWS.
#
# Add your resources here.
#
# Tip: Keep resources grouped by purpose and add brief comments for readability.

locals {
  tags = var.tags
}

# Example placeholder resource (commented)
# resource "aws_s3_bucket" "this" {
#   bucket = var.name
#   tags   = local.tags
# }

