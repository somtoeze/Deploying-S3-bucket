# IAM Policy - Defines what permissions the app needs
resource "aws_iam_policy" "app_s3_policy" {
  name        = "app-s3-access-policy"
  description = "Allows application to read/write to Olivan App Assets S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::olivan-app-assets-660119432667",
          "arn:aws:s3:::olivan-app-assets-660119432667/*"
        ]
      }
    ]
  })
}

# IAM User - The application will use these credentials
resource "aws_iam_user" "app_user" {
  name = "app-user"

  tags = {
    Name        = "olivian_app_user"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "app_user_policy" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.app_s3_policy.arn
}

# Generate access keys for the user (these are what your app uses)
resource "aws_iam_access_key" "app_user_key" {
  user = aws_iam_user.app_user.name
}

# Output the credentials (SAVE THESE IMMEDIATELY!)
output "app_user_access_key_id" {
  value     = aws_iam_access_key.app_user_key.id
  sensitive = true
}

output "app_user_secret_access_key" {
  value     = aws_iam_access_key.app_user_key.secret
  sensitive = true
}

output "app_user_arn" {
  value = aws_iam_user.app_user.arn
}