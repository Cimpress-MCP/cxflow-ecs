resource "aws_ecs_cluster" "cluster" {
  name = var.name

  setting {
    name = "containerInsights"
    value = var.container_insights
  }

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}


data "template_file" "task_definition" {
  template = file("${path.module}/cxflow-task-definition.json")

  vars = {
    environment = var.environment
    account_id = data.aws_caller_identity.current.account_id
    task_role_arn = aws_iam_role.ecs_task_execution_role.arn
    region = var.region
  }
}

resource "aws_ecs_task_definition" "cxflow" {
  family = "cxflow"
  container_definitions = data.template_file.task_definition.rendered

  tags = local.all_tags
}

resource "aws_ecs_service" "cxflow" {
  name = var.name
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.cxflow.arn
  desired_count = var.desired_service_count
  iam_role = aws_iam_role.ecs_service.name

  network_configuration {
    subnets = module.vpc.public_subnets.*.ids
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cxflow.id
    container_name = aws_ecr_repository.cxflow.name
    container_port = "8080"
  }

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}
