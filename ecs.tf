resource "aws_ecs_cluster" "cluster" {
  name = "cxflow-${var.environment}"

  setting {
    name = "containerInsights"
    value = var.container_insights
  }

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}


data "template_file" "container_definitions" {
  template = file("${path.module}/ecs-container-definitions.json")

  vars = {
    environment = var.environment
    account_id = data.aws_caller_identity.current.account_id
    region = var.region
  }
}

resource "aws_ecs_task_definition" "cxflow" {
  family = "cxflow-${var.environment}"
  container_definitions = data.template_file.container_definitions.rendered
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "awsvpc"
  memory = "2048"
  cpu = "512"
  requires_compatibilities = ["FARGATE"]

  tags = local.all_tags
}

resource "aws_ecs_service" "cxflow" {
  name = "cxflow-${var.environment}"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.cxflow.arn
  desired_count = var.desired_service_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = module.vpc.public_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  tags = merge(local.all_tags, {
    "Name" = "cxflow-${var.environment}"
  })
}
