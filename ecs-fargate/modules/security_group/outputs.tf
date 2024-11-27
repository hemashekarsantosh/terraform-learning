output "sg_id" {
  value = aws_security_group.sg_fargate.id
}

output "alb_sg_id" {
  value = aws_security_group.sg_alb.id
}