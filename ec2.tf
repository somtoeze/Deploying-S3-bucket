# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group - allows HTTP and SSH access
resource "aws_security_group" "web_sg" {
  name        = "olivan-web-server-sg"
  description = "Security group for Olivan web server"
  vpc_id      = "vpc-0392b047cc27940fa"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["165.210.39.32/32"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "olivan-web-server-sg"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# IAM Instance Profile - allows EC2 to access S3
resource "aws_iam_role" "ec2_s3_role" {
  name = "olivan-ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "olivan-ec2-s3-access-role"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Attach S3 read-only policy to the role
resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "olivan-ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = "subnet-01e2d8249c058365c"
  associate_public_ip_address = true   # ← ADDED THIS

   # ADD THIS METADATA OPTIONS BLOCK
  metadata_options {
    http_tokens   = "required"   # Enforces IMDSv2
    http_put_response_hop_limit = 1
  }

  # User Data - runs when instance starts
  user_data = <<-EOF
    #!/bin/bash
    # Update system
    yum update -y

    # Install Apache web server
    yum install -y httpd

    # Install AWS CLI
    yum install -y aws-cli

    # Start and enable Apache
    systemctl start httpd
    systemctl enable httpd

    # Create a simple web page
    cat > /var/www/html/index.html << HTML
    <!DOCTYPE html>
    <html>
    <head>
        <title>Olivan App - EC2</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                text-align: center;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            h1 { font-size: 3rem; margin-bottom: 10px; }
            .info { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; margin: 20px 0; }
            .tag { background: #ff6b6b; padding: 5px 15px; border-radius: 20px; display: inline-block; }
        </style>
    </head>
    <body>
        <div class="tag">EC2</div>
        <h1>🚀 Olivan App</h1>
        <div class="info">
            <p>Running on EC2 Instance</p>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
        </div>
        <p>Deployed with Terraform on $(date)</p>
    </body>
    </html>
    HTML

    # Set proper permissions
    chmod 644 /var/www/html/index.html
  EOF

  tags = {
    Name        = "olivan-web-server"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Output the public IP
output "ec2_public_ip" {
  value = aws_instance.web_server.public_ip
  description = "Public IP of the EC2 instance"
}

output "ec2_public_dns" {
  value = aws_instance.web_server.public_dns
  description = "Public DNS of the EC2 instance"
}