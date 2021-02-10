# terraform-aws-sfn-ecs-integration
A Terraform module that demonstrates how to integrate AWS Elastic Container Service (ECS) with AWS Step Functions to spin up ad-hoc containers and pass dynamic data to them.

The module creates an AWS Step Functions state machine that runs a Fargate task that simply `echo`es the JSON-encoded state machine execution input.
