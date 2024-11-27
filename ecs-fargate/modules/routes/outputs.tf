output "private-route-table-id" {
  value = aws_route_table.aws_private_route.id
}

output "public-route-table-id" {
  value = aws_route_table.aws_public_route.id
}