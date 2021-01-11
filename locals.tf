locals {
  all_tags = merge(var.tags, {
    "Terraform"   = "true"
  })
}
