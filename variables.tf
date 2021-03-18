variable "region" {
  type        = string
  description = "The region to deploy the cluster into"
}

variable "dns_zone" {
  type        = string
  description = "The name of the Route 53 DNS zone to use for the domain name"
}

variable "domain" {
  type        = string
  description = "The domain to host the cluster on"
}

variable "name" {
  type        = string
  description = "A name for this cluster.  The actual name assigned to resources will be {var.name}-{var.evnironment}"
  default     = "cxflow"
}

variable "desired_service_count" {
  type        = number
  description = "The desired number of instances in the ECS service"
  default     = "1"
}

variable "environments" {
  type        = map
  default     = { "production" : "stable" }
  description = "Environments to build services for.  Should be a map with the environment name as the key and the container tag reference as the value"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block to apply to the full VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC."
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Provides a resource to create a VPC NAT Gateway."
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "All private subnets will route their Internet traffic through this single NAT gateway. The NAT gateway will be placed in the first public subnet in your public_subnets block."
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "A list of CIDR blocks to use for the private subnets"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "A list of CIDR blocks to use for the public subnets"
}

variable "flow_log_bucket" {
  type        = string
  default     = ""
  description = "An S3 bucket to send VPC flow logs to"
}

variable "container_insights" {
  type    = string
  default = "enabled"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags to apply to all resources"
}

variable "ecr_image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository."
}

variable "ecr_scan_on_push" {
  type        = bool
  default     = true
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
}

variable "ecr_encryption_type" {
  type        = string
  default     = "AES256"
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256."
}

variable "gitlab-cidr-range" {
  type        = list(string)
  default     = ["34.74.90.64/28", "34.74.226.0/24"]
  description = "GitLab.com is using the IP range 34.74.90.64/28 & 34.74.226.0/24 for traffic from its Web/API fleet."
}
