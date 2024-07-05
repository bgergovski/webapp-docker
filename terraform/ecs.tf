resource "aws_cloudwatch_log_group" "webapp" {
  name = "webapp-docker"

  retention_in_days = 7

  tags = merge(local.tags)
}

resource "aws_ecs_cluster" "webapp" {
  name = var.service_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.webapp.name
      }
    }
  }

  tags = merge(local.tags)
}

resource "aws_ecs_service" "webapp" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.webapp.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [
      aws_subnet.webapp_a.id,
      aws_subnet.webapp_b.id
    ]
    security_groups  = [aws_security_group.webapp_ecs.id]
    assign_public_ip = true
  }
  load_balancer {
    container_name   = "${var.service_name}"
    container_port   = "80"
    target_group_arn = aws_lb_target_group.webapp_ecs.arn
  }
  desired_count = 1

  lifecycle {
    ignore_changes = [desired_count]
  }
  tags = merge(local.tags)
}

resource "aws_ecs_task_definition" "webapp" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = aws_iam_role.webapp_ecs.arn
  tags                     = merge(local.tags)
  container_definitions    = <<EOF
[
  {
    "name": "${var.service_name}",
    "image": "${aws_ecr_repository.webapp.repository_url}:${var.docker_tag}",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "healthCheck": {
      "retries": 3,
      "command": [
        "CMD-SHELL",
        "curl -vvv http://localhost/health || exit 1"
      ],
      "timeout": 5,
      "interval": 30,
      "startPeriod": null
    }
  }
]
EOF
}