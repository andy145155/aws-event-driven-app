# VPC Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "public_subnet_group_name" {
  value = module.vpc.public_subnet_group_name
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "private_subnet_group_name" {
  value = module.vpc.private_subnet_group_name
}
output "public_subnet_a_id" {
  value = module.vpc.public_subnet_a_id
}
output "public_subnet_b_id" {
  value = module.vpc.public_subnet_b_id
}
output "private_subnet_a_id" {
  value = module.vpc.private_subnet_a_id
}
output "private_subnet_b_id" {
  value = module.vpc.private_subnet_b_id
}

# Lambda Outputs
output "lambda_iam_role_arn" {
  value = module.lambda.lambda_iam_role_arn
}

output "lambda_security_group_id" {
  value = module.lambda.lambda_security_group_id
}

# IAM Outputs
output "current_iam_caller_account_id" {
  value = module.iam.current_iam_caller_account_id
}
output "rds_connect_policy_arn" {
  value = module.iam.rds_connect_policy_arn
}

# S3 Outputs
output "event_driven_app_csv_buckets_id" {
  value = module.s3.event_driven_app_csv_buckets_id
}

output "event_driven_app_csv_buckets_arn" {
  value = module.s3.event_driven_app_csv_buckets_arn
}

output "event_driven_app_csv_buckets_name" {
  value = module.s3.event_driven_app_csv_buckets_name
}

output "s3_vpce_prefix_list" {
  value = module.s3.s3_vpce_prefix_list
}

output "event_driven_app_ssl_buckets_name" {
  value = module.s3.event_driven_app_ssl_buckets_name
}


# SQS Outputs
output "sqs_arn" {
  value = module.sqs.sqs_arn
}

# RDS Outputs
output "rds_security_group_id" {
  value = module.mysql_db.rds_security_group_id
}
output "vpc_endpoint_ssm_security_group_id" {
  value = module.mysql_db.vpc_endpoint_ssm_security_group_id
}

