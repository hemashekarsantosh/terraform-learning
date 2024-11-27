resource "aws_ecs_service" "ecs_service" {
  name = "app-service"
  task_definition = var.task_definition
  cluster = var.cluster_id
  desired_count = 1
  
 
  network_configuration {
    assign_public_ip = false
    subnets = [var.subnets]
    security_groups = [var.security_group]
  }
  load_balancer {
    target_group_arn = var.alb_arn
    container_name = "my-container"
    container_port = 8080
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base = 0
    weight = 1
  }
}

#

