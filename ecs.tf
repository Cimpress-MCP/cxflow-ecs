resource "aws_ecs_cluster" "cluster" {
  name               = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = {
    "Name"      = var.ecs_cluster_name
    "Squad"     = var.squad
    "Terraform" = "true"
  }

}
