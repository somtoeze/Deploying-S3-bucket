terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

#   backend "s3" {
#     bucket  = "startup-terraform-state-662667"
#     key     = "dev/terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#   }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket for Olivan App Assets
resource "aws_s3_bucket" "app_bucket" {
  bucket = "olivan-app-assets-6632667"

  tags = {
    Name        = "Olivan App Assets"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Block public access by default (security best practice)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning (so you can recover deleted files)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Get current account info
data "aws_caller_identity" "current" {}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.app_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.app_bucket.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
