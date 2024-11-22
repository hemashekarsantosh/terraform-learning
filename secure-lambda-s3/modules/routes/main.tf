resource "aws_route_table" "aws_private_route" {
  vpc_id = var.vpc_id
  tags = {
    "Name":"private-route-table"
  }
}