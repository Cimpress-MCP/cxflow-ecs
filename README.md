# CxFlow

This repository manages a module to deploy an AWS ECS cluster for use with CxFlow.

This is really just a generic ECS cluster, but the security group rules are specific to a CxFlow cluster intended for integration with Gitlab

## Using

This is intended to be used as a module and so can be embedded in other Terraform repositories.  The best way to see how to use it is by cloning and trying out the example repository on how to use this:

https://github.com/Cimpress-MCP/cxflow-ecs-example

## Resources

This repository builds the following resources:

- A VPC with private and public subnets
- A basic IAM role for the cluster
- A security group for the cluster allowing access from a load balancer security group
- A load balancer security group that allows traffic from the Gitlab runner IP address range
- An ECR repository to for storing/deploying containers to the cluster
- An ECS cluster
- An application load balancer (note: not finished yet)
