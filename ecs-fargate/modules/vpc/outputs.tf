output "vpc_id" {
  value = aws_vpc.secure_vpc.id
}

output "cidr_block" {
  value = aws_vpc.secure_vpc.cidr_block
}