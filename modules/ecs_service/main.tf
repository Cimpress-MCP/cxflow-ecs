data "aws_caller_identity" "current" {}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-${var.environment}-ecs-task"
  vpc_id      = var.vpc_id
  description = "Allow inbound access from the ALB only"

  ingress {
    description     = "Allow inbound access from the ECS ALB only (SG lb-sg)"
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow all from ECS"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-ecs-task"
  })
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cxflow.arn
  }

  condition {
    path_pattern {
      values = ["/${var.environment}"]
    }
  }
}

resource "aws_lb_target_group" "cxflow" {
  name        = "${var.name}-${var.environment}"
  port        = 443
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "120"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/actuator/health"
    unhealthy_threshold = "2"
  }
}

data "template_file" "container_definitions" {
  template = file("${path.module}/ecs-container-definitions.json")

  vars = {
    name        = var.name
    environment = var.environment
    account_id  = data.aws_caller_identity.current.account_id
    region      = var.region
    container_tag = var.container_tag
  }
}

resource "aws_ecs_task_definition" "cxflow" {
  family                   = "${var.name}-${var.environment}"
  container_definitions    = data.template_file.container_definitions.rendered
  execution_role_arn       = var.ecs_role_arn
  task_role_arn            = var.ecs_role_arn
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"]

  tags = var.tags
}

resource "aws_ecs_service" "cxflow" {
  name            = "${var.name}-${var.environment}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.cxflow.arn
  desired_count   = var.desired_service_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cxflow.arn
    container_name   = "${var.name}-${var.environment}"
    container_port   = 8080
  }

  tags = merge(var.tags, {
    "Name" = "${var.name}-${var.environment}"
  })
}

resource "aws_cloudwatch_log_group" "cxflow" {
  name = "/app/${var.name}-${var.environment}"
  retention_in_days = "30"

  tags = merge(var.tags, {
    "Name" = "${var.name}-${var.environment}"
  })
}
