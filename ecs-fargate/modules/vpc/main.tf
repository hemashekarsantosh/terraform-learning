resource "aws_vpc" "secure_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name":"secure_vpc"
  }
}