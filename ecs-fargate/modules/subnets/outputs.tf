output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet_cidr_block" {
  value = aws_subnet.private_subnet.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_cidrblock" {
  value = aws_subnet.public_subnet.cidr_block
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet-1.id
}