output "current_iam_caller_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "rds_connect_policy_arn" {
  value = aws_iam_policy.rds_connection.arn
}
