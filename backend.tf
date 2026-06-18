# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "startup-terraform-state-660119432667" # ← YOUR ACTUAL ACCOUNT ID

#   lifecycle {
#     prevent_destroy = true
#   }

#   tags = {
#     Name    = "Terraform State Storage"
#     Purpose = "Shared Terraform state for all team members"
#   }
# }

# resource "aws_s3_bucket_versioning" "state_versioning" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }