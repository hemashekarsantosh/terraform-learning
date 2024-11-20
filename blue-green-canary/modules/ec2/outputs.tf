# Output the instance ID to use in main.tf for target group registration
output "id" {
  value = aws_instance.this.id
}