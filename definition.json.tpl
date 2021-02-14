{
  "Comment": "State machine integrated with ECS",
  "StartAt": "Initial",
  "States": {
    "Initial": {
      "Type": "Task",
      "Resource": "arn:aws:states:::ecs:runTask.sync",
      "Parameters": {
        "Cluster": "${ECS_CLUSTER_ARN}",
        "LaunchType": "FARGATE",
        "PlatformVersion": "LATEST",
        "TaskDefinition": "${ECS_TASK_DEFINITION_ARN}",
        "NetworkConfiguration": {
          "AwsvpcConfiguration": {
            "Subnets": ${SUBNETS},
            "AssignPublicIp": "ENABLED"
          }
        },
        "Overrides": {
          "ContainerOverrides": ${ECS_CONTAINER_OVERRIDES}
        }
      },
      "TimeoutSeconds": 3600,
      "End": true
    }
  }
}
