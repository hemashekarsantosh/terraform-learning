output "arn" {
  value = aws_alb.alb.arn
}

output "dns_ulr" {
  value = aws_alb.alb.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}