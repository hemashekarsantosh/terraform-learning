resource "aws_ecs_service" "ecs_service" {
  name = "app-service"
  task_definition = var.task_definition
  cluster = var.cluster_id
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    assign_public_ip = true
    subnets = [var.subnets]
    security_groups = [var.security_group]
  }
}

#

