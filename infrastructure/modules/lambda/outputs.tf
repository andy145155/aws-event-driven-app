output "lambda_iam_role_arn" {
  value = aws_iam_role.lambda.arn
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda.id
}
