data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "lambda" {
  name               = "${var.service}-lambda-execute-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
}

data "aws_iam_policy_document" "lambda_exec_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",

      # NOTE: Below 3 *NetworkInterface* rules are necessary per described in https://docs.aws.amazon.com/lambda/latest/dg/vpc.html
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",

      "secretsmanager:GetSecretValue",

      "s3:GetObject",
      "s3:GetBucketPolicy",

      "rds:*",

      # Lambda receive SQS messages actions
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"

    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "iam-policy-lambda-role"
  path        = "/"
  description = "IAM Policy for managing aws lambda role"
  policy      = data.aws_iam_policy_document.lambda_exec_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_2" {
  role       = aws_iam_role.lambda.name
  policy_arn = var.rds_connect_policy_arn
}

resource "aws_security_group" "lambda" {
  vpc_id      = var.vpc_id
  name        = "${var.service}-lambda"
  description = "${var.service} lambda security group"
  tags = {
    Name = "${var.service}-lambda-security-group"
  }
}

resource "aws_security_group_rule" "s3_gateway_egress" {
  description       = "S3 Gateway Egress"
  type              = "egress"
  security_group_id = aws_security_group.lambda.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [var.s3_vpce_prefix_list.id]
}

resource "aws_security_group_rule" "rds_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.rds_security_group_id
  security_group_id        = aws_security_group.lambda.id
}

resource "aws_security_group_rule" "ssm_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.vpc_endpoint_ssm_security_group_id
  security_group_id        = aws_security_group.lambda.id
}

