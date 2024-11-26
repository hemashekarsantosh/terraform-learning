resource "aws_ecs_task_definition" "app_definition" {
  family = "app-definition"
  cpu = "256"
  memory = "512"
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.execution_role_arn
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  container_definitions = jsonencode([{
    name = "my-container"
    image = "${var.repository_url}:${var.image_tag}"
    essential = true
    portMappings =[{
        containerPort= "${var.containerPort}"
        hostPort= "${var.hostPort}"
    }]
  }])
}