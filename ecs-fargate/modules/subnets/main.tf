# Create Private Subnet if var.private_subnet is true
resource "aws_subnet" "private_subnet" {
  

  cidr_block              = "10.0.0.0/25"
  availability_zone        = var.availability_zone
  vpc_id                   = var.vpc_id
  map_public_ip_on_launch = false  # Private subnet does not assign public IPs
  tags = {
    Name = "private-subnet"
  }
}

# Create Public Subnet if var.private_subnet is false
resource "aws_subnet" "public_subnet" {

  cidr_block              = "10.0.1.0/25"
  availability_zone        = var.availability_zone
  vpc_id                   = var.vpc_id
  map_public_ip_on_launch = true   # Public subnet assigns public IPs
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public_subnet-1" {

  cidr_block              = "10.0.2.0/25"
  availability_zone        = "us-west-2b"
  vpc_id                   = var.vpc_id
  map_public_ip_on_launch = true   # Public subnet assigns public IPs
  tags = {
    Name = "public-subnet-1"
  }
}
