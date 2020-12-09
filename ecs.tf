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
