resource "aws_route_table" "aws_private_route" {
  vpc_id = var.vpc_id
  tags = {
    "Name":"private-route-table"
  }
}

resource "aws_route_table" "aws_public_route" {
  vpc_id = var.vpc_id
  tags = {
    "Name":"Public-route-table"
  }
 route {
  gateway_id = var.gateway_id
  cidr_block = "0.0.0.0/0"
 }
}

