variable "region" {
  type = string
  description = "The region to deploy the cluster into"
}

variable "dns_zone" {
  type = string
  description = "The name of the Route 53 DNS zone to use for the domain name"
}

variable "domain" {
  type = string
  description = "The domain to host the cluster on"
}

variable "name" {
  type = string
  description = "A name for this cluster.  The actual name assigned to resources will be {var.name}-{var.evnironment}"
  default = "cxflow"
}

variable "desired_service_count" {
  type = number
  description = "The desired number of instances in the ECS service"
  default = "1"
}

variable "squad" {
  type = string
  default = ""
  description = "Squad, which could be your squad name or abbreviation, e.g. 'krypton' or 'kyp'"
}

variable "environment" {
  type = string
  default = "development"
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "The CIDR block to apply to the full VPC"
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "A list of CIDR blocks to use for the private subnets"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "A list of CIDR blocks to use for the public subnets"
}

variable "container_insights" {
  type = string
  default = "enabled"
}

variable "tags" {
  type = map
  default = {}
  description = "Additional tags to apply to all resources"
}
