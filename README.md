Deploying S3 Bucket - Olivan App Infrastructure
Project Overview
This Terraform project deploys AWS infrastructure for the Olivan App, including an S3 bucket, CloudFront CDN, and EC2 web server.

Infrastructure Components
S3 Bucket: Static website hosting with versioning

CloudFront: CDN with HTTPS support

EC2: Web server with Apache

IAM: Secure access management

Elastic IP: Static public IP

Deployment Steps
Prerequisites
AWS Account (us-east-1)

Terraform

AWS CLI configured

SSH key pair

Quick Deploy
bash
terraform init
terraform plan
terraform apply -auto-approve
Outputs
bash
terraform output  # View EC2 IP, CloudFront URL, etc.
Access
EC2 Web Server: http://[EC2_PUBLIC_IP]

CloudFront URL: https://[CLOUDFRONT_URL].cloudfront.net

Clean Up
bash
terraform destroy -auto-approve
Project Completed By
Eze Somtochukwu