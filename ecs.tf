resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-${var.environment}"

  setting {
    name = "containerInsights"
    value = var.container_insights
  }

  tags = merge(local.all_tags, {
    "Name" = "${var.name}-${var.environment}"
  })
}


data "template_file" "container_definitions" {
  template = file("${path.module}/ecs-container-definitions.json")

  vars = {
    name = var.name
    environment = var.environment
    account_id = data.aws_caller_identity.current.account_id
    region = var.region
  }
}

resource "aws_ecs_task_definition" "cxflow" {
  family                   = "${var.name}-${var.environment}"
  container_definitions    = data.template_file.container_definitions.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"]

  tags = local.all_tags
}

resource "aws_ecs_task_definition" "cxflow-dev" {
  family                = "${var.name}-${var.environment}-dev"
  container_definitions = <<TASK_DEFINITION
[
  {
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080,
        "protocol": "http"
      }
    ],
    "essential": true,
    "name": "${name}-${environment}-dev",
    "image": "${account_id}.dkr.ecr.${region}.amazonaws.com/${name}-${environment}:latest",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/app/${name}-${environment}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${name}-dev"
      }
    },
    "secrets": [
      {
        "name": "CHECKMARX_USERNAME",
        "valueFrom": "/${name}/${environment}/checkmarx/username"
      },
      {
        "name": "CHECKMARX_PASSWORD",
        "valueFrom": "/${name}/${environment}/checkmarx/password"
      },
      {
        "name": "CHECKMARX_BASE_URL",
        "valueFrom": "/${name}/${environment}/checkmarx/url"
      },
      {
        "name": "CX_FLOW_TOKEN",
        "valueFrom": "/${name}/${environment}/checkmarx/token"
      },
      {
        "name": "GITLAB_TOKEN",
        "valueFrom": "/${name}/${environment}/gitlab/token"
      },
      {
        "name": "GITLAB_WEBHOOK_TOKEN",
        "valueFrom": "/${name}/${environment}/gitlab/webhook-token"
      }
    ]
  }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "cxflow" {
  name            = "${var.name}-${var.environment}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.cxflow.arn
  desired_count   = var.desired_service_count
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cxflow.arn
    container_name   = "${var.name}-${var.environment}"
    container_port   = 8080
  }

  tags = merge(local.all_tags, {
    "Name" = "${var.name}-${var.environment}"
  })
}


resource "aws_ecs_service" "cxflow-dev" {
  name            = "${var.name}-${var.environment}-dev"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.cxflow-dev.arn
  desired_count   = var.desired_service_count
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cxflow-dev.arn
    container_name   = "${var.name}-${var.environment}-dev"
    container_port   = 8080
  }

  tags = merge(local.all_tags, {
    "Name" = "${var.name}-${var.environment}-dev"
  })
}
