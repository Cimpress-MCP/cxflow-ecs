variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "squad" {
  type        = string
  default     = ""
  description = "Squad, which could be your squad name or abbreviation, e.g. 'krypton' or 'kyp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "cidr_block" {
  type    = string
  default = ""
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "enable_dns_support" {
  type    = bool
  default = false
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "ecs_cluster_name" {
  type    = string
  default = ""
}

variable "container_insights" {
  type    = string
  default = "enabled"
}



