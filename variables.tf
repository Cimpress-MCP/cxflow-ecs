variable "name" {
  type = string
  description = "A name to apply to all resources"
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

variable "enable_dns_support" {
  type = bool
  default = false
  description = "Set to true to enable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  type = bool
  default = false
  description = "Set to true to enable DNS hostnames in the VPC"
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
