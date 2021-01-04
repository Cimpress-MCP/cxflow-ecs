locals {
  all_tags = merge(var.tags, {
    "Environment" = var.environment,
    "Terraform" = "true"
  })
}
