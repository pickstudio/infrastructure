output "role_exec_arn" {
  value = aws_iam_role.exec.arn
}

output "role_task_arn" {
  value = aws_iam_role.task.arn
}

output "cloudwatch_log" {
  value = aws_cloudwatch_log_group.log_group.name
}