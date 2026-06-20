resource "aws_eip" "web_eip" {
  instance = "i-0582d86ee07a35df1"
  domain   = "vpc"

  tags = {
    Name = "olivan-web-eip"
  }
}

output "elastic_ip" {
  value = aws_eip.web_eip.public_ip
}