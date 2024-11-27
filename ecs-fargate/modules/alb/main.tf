resource "aws_alb" "alb" {
  name = "alb-fargate"
  internal = false
  security_groups = [var.security_groups]
  subnets = var.subnets
  
  
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 8080        # Port for your application
  protocol = "HTTP"
  vpc_id   = var.vpc_id  # VPC ID
  target_type = "ip"

  health_check {
    path                = "/"  # Health check path, adjust as per your service
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "ECS-Target-Group"
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
