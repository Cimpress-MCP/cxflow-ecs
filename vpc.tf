data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr_block
  azs = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}
