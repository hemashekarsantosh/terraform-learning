resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.0.0/25"
  availability_zone = var.availability_zone
  vpc_id = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }
}