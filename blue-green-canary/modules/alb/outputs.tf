output "blue_target_group_arn" {
  value = aws_alb_target_group.blue.arn
}

output "green_target_group_arn" {
  value = aws_alb_target_group.green.arn
}

output "load_balancer_dns" {
  value = aws_alb.this.dns_name
}