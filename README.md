# Deploying-S3-bucket
Deployed production-grade S3 infrastructure using Terraform with remote state management.


# Infrastructure - S3 Bucket with Terraform

## Overview
Terraform configuration to deploy secure S3 buckets with versioning, encryption, and remote state management for team collaboration.

## Resources Deployed
- S3 bucket for application assets (versioning enabled, public access blocked)
- S3 bucket for Terraform remote state (encrypted, versioned)

## Commands
```bash
terraform init
terraform plan
terraform apply
