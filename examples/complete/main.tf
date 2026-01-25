terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "module-template" {
  source = "../../"

  name = "example-complete"
  tags = {
    Environment = "dev"
    Module      = "terraform-aws-module-template"
    Owner       = "platform"
  }
}

