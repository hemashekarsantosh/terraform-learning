resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecsTaskExecutionPolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

resource "aws_iam_policy" "alb_register_targets" {
  name        = "ECSALBRegisterTargetsPolicy"
  description = "Policy allowing ECS to register and deregister tasks with the ALB target group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:registerTargets",
          "elasticloadbalancing:deregisterTargets",
          "elasticloadbalancing:describeTargetGroups",
          "elasticloadbalancing:describeTargetHealth"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

/*resource "aws_iam_role" "ecs_service_linked_role" {
  name               = "AWSServiceRoleForECS"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Effect    = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "alb_register_targets_policy_attachment" {
  name       = "alb-register-targets-policy-attachment"
  policy_arn = aws_iam_policy.alb_register_targets.arn
  roles      = [aws_iam_role.ecs_service_linked_role.name]
}*/
