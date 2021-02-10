data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  name_prefix        = "${var.name_prefix}-sfn-ecs"
  current_account_id = data.aws_caller_identity.this.account_id
  current_region     = data.aws_region.this.name
  ecs_container_name = "main"
}

resource "aws_sfn_state_machine" "this" {
  name = local.name_prefix
  definition = templatefile("${path.module}/definition.json.tmpl", {
    ECS_CLUSTER_ARN         = aws_ecs_cluster.this.arn
    ECS_TASK_DEFINITION_ARN = aws_ecs_task_definition.this.arn
    ECS_CONTAINER_NAME      = local.ecs_container_name
    SUBNETS                 = jsonencode(var.public_subnet_ids)
  })
  role_arn = aws_iam_role.this.arn
  tags     = var.tags
}

resource "aws_iam_role" "this" {
  name               = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.sfn_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_to_sfn" {
  policy = data.aws_iam_policy_document.ecs_for_sfn.json
  role   = aws_iam_role.this.id
}

resource "aws_ecs_cluster" "this" {
  name = local.name_prefix
  tags = var.tags
}

resource "aws_iam_role" "task" {
  name               = "${local.name_prefix}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  tags               = var.tags
}

resource "aws_iam_role" "task_execution" {
  name               = "${local.name_prefix}-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "managed_policy_to_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution.id
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.name_prefix
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.task_execution.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name  = local.ecs_container_name
      image = "vydev/awscli"
      entryPoint = [
        "/bin/bash",
        "-c"
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = local.current_region
          awslogs-stream-prefix = local.name_prefix
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.name_prefix
  retention_in_days = 14
  tags              = var.tags
}
