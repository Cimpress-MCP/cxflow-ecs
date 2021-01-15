variable "region" {
  type        = string
  description = "The region the ECS cluster was deployed to"
}

variable "name" {
  type        = string
  description = "A name for this service."
}

variable "domain" {
  type        = string
  description = "The domain that this service should listen on"
}

variable "desired_service_count" {
  type        = number
  description = "The desired number of instances in the ECS service"
}

variable "environment" {
  type        = string
  description = "The name of the environment for this service"
}

variable "container_tag" {
  type        = string
  description = "The tag of the container to launch in the tas.  Something like 'latest' or 'stable'"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC to launch everything in"
}

variable "alb_security_group_id" {
  type        = string
  description = "The id of the ALB security group"
}

variable "ecs_role_arn" {
  type        = string
  description = "The ARN of the role to use for ECS"
}

variable "ecs_cluster_id" {
  type        = string
  description = "The id the ECS cluster to launch the service in"
}

variable "lb_listener_arn" {
  type        = string
  description = "The ARN of the load balancer listener to attach the service to"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of the ids of the private subnets to launch tasks in"
}

variable "tags" {
  type        = map
  description = "Additional tags to apply to all resources"
}
