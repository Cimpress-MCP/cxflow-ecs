data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

locals {
  bucket_name = var.flow_log_bucket != "" ? var.flow_log_bucket : "cimpress-security-flowlogs-${data.aws_caller_identity.current.account_id}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.name
  cidr                 = var.cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway

  tags = merge(local.all_tags, {
    "Name" = var.name
  })
}

resource "aws_flow_log" "aws_flowlogs" {
  log_destination      = "arn:aws:s3:::${local.bucket_name}/${module.vpc.vpc_id}/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
}
