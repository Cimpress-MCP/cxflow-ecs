# CxFlow

This repository manages a module to deploy CxFlow to AWS ECS

## Using

This is intended to be used as a module and so can be embedded in other Terraform repositories.  The best way to see how to use it is by cloning and trying out the example repository on how to use this, which includes additional details on how to launch a fully functional CxFlow service:

https://github.com/Cimpress-MCP/cxflow-ecs-example

## Resources

This repository builds the following resources:

- A VPC for the cluster
- An ECR repository for storing/deploying containers for the cluster
- SSM Parameters that CxFlow needs (although it does not populate the values - [more below](#SSM-Parameters))
- Necessary IAM roles and Security groups for the cluster and all related resources
- An Application load balancer (which only accepts traffic from Gitlab's public runners)
- An ACM for the ALB, automatically registered via DNS
- An ECS cluster
- An ECS service
- The CxFlow task definition

## External Resources

This repository requires the following external items in order to actually do anything:

- The CxFlow image must be built and saved into the ECR repository with the `latest` tag
- The SSM parameters must be populated with the [necessary values](#SSM-Parameters)
- A Route53 hosted zone
- A running checkmarx server

## Architecture

Below is an architecture diagram for the resulting cluster:

![CxFlow architecture diagram](cxflow_architecture_diagram.png)

## Variables

Terraform accepts the following

## SSM Parameters
