output "state_machine_arn" {
  value = aws_sfn_state_machine.this.arn
}

output "task_role_name" {
  value = aws_iam_role.task.name
}
