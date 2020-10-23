provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.vpc_id
  cidr                 = var.cidr_block
  azs                  = data.aws_availability_zones.available.names
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    "Name"      = var.vpc_id
    "Squad"     = var.squad
    "Terraform" = "true"
  }
}
