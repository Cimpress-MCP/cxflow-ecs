data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "cimpress-security-flowlogs" {
  bucket = "cimpress-security-flowlogs-${data.aws_caller_identity.current.account_id}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-${var.environment}"
  cidr = var.cidr_block
  azs = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = merge(local.all_tags, {
    "Name" = "${var.name}-${var.environment}"
  })
}

resource "aws_flow_log" "aws_flowlogs" {
  log_destination      = "${data.aws_s3_bucket.cimpress-security-flowlogs.arn}/${module.vpc.vpc_id}/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
}

