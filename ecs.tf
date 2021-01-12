resource "aws_ecs_cluster" "cluster" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}

module "cxflow_service" {
  for_each = var.environments
  source   = "./modules/ecs_service"

  name                  = var.name
  environment           = each.key
  container_tag         = each.value
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = aws_security_group.alb.id
  region                = var.region
  ecs_role_arn          = aws_iam_role.ecs_task_execution_role.arn
  ecs_cluster_id        = aws_ecs_cluster.cluster.id
  desired_service_count = var.desired_service_count
  private_subnet_ids    = module.vpc.private_subnets
  lb_listener_arn       = aws_lb_listener.cxflow.arn
  tags                  = local.all_tags

  depends_on = [aws_lb.cxflow]
}
