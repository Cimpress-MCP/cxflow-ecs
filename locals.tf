locals {
  all_tags = merge(var.tags, {
    "Environment" = var.environment,
    "Terraform Version" = var.terraform_version,
    "Terraform" = "true",
    "Squad" = var.squad
  })
}
