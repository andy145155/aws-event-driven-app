# Get the current IAM user or role 
data "aws_caller_identity" "current" {}

data "aws_iam_user" "user" {
  user_name = var.iam_user_name
}

resource "aws_iam_policy" "rds_connection" {
  name        = "${var.service}-rds-iam-connection"
  path        = "/"
  description = "iam policy for connecting ${var.service} DB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "rds-db:connect"
      Resource = "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.db_resource_id}/${var.db_user}"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "movie_app_user_rds_connect" {
  user       = data.aws_iam_user.user.user_name
  policy_arn = aws_iam_policy.rds_connection.arn
}


