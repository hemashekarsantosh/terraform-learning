resource "aws_alb" "this" {
  name = var.name
  internal = false
  load_balancer_type = "application"
  security_groups = var.security_groups
  subnets = var.subnets
}



resource "aws_alb_target_group" "blue" {
  name ="blue-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    port = 80
    protocol = "HTTP"
    path = "/"
    enabled = true
    interval = 10
  }
}

resource "aws_alb_target_group" "green" {
  name ="green-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    port = 80
    protocol = "HTTP"
    path = "/"
    enabled = true
    interval = 10
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port = 80
  protocol = "HTTP"
    default_action {
      type = "forward"
      forward {
        target_group {
          arn = aws_alb_target_group.blue.arn
          weight = 50
        }
        target_group {
          arn = aws_alb_target_group.green.arn
          weight = 50
        }
      }
     
    }
}

