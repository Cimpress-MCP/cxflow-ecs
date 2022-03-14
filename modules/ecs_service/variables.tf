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

# CPU value 	  | Memory value (MiB)
# 256 (.25 vCPU)| 512 (0.5GB), 1024 (1GB), 2048 (2GB)
# 512 (.5 vCPU) |	1024 (1GB), 2048 (2GB), 3072 (3GB), 4096 (4GB)
# 1024 (1 vCPU) | 2048 (2GB), 3072 (3GB), 4096 (4GB), 5120 (5GB), 6144 (6GB), 7168 (7GB), 8192 (8GB)
# 2048 (2 vCPU) |	Between 4096 (4GB) and 16384 (16GB) in increments of 1024 (1GB)
# 4096 (4 vCPU) |	Between 8192 (8GB) and 30720 (30GB) in increments of 1024 (1GB)

variable "task_definition_cxflow_cpu" {
  type        = number
  description = "Specify a supported value for the task CPU units, 256,512,1024,2048 etc"
  default     = "512"
}

variable "task_definition_cxflow_memory" {
  type        = number
  description = "Specify a supported value for the task Memory units - 512,1024,2048 etc"
  default     = "2048"
}
