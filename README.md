**Deploying S3 Bucket and Olivan App Infrastructure**



**Project Completed By
Eze Somtochukwu**



Project Overview
This Terraform project deploys AWS infrastructure for the Olivan App, including an 



✅ S3 Bucket – Static website hosting with versioning and encryption


✅ EC2 Web Server – Apache running with automated bootstrapping

✅ IAM – Least‑privilege access with users, roles, and policies

✅ VPC & Networking – Public subnet, Security Groups, and Elastic IP


✅ Security Best Practices – IMDSv2 and secure configurations

Infrastructure Components
S3 Bucket: Static website hosting with versioning

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


Clean Up
bash

terraform destroy -auto-approve




