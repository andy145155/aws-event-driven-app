provider "aws" {
  region = var.region
}

module "vpc" {
  source           = "./modules/vpc"
  main_vpc_cidr    = var.main_vpc_cidr
  public_subnet_a  = var.public_subnet_a
  private_subnet_a = var.private_subnet_a
  public_subnet_b  = var.public_subnet_b
  private_subnet_b = var.private_subnet_b
  dns_support      = var.dns_support
  dns_hostnames    = var.dns_hostnames
  state            = var.state
  service          = var.service
}

module "mysql_db" {
  source                   = "./modules/rds"
  region                   = var.region
  allocated_storage        = var.allocated_storage
  engine                   = var.engine
  engine_version           = var.engine_version
  instance_class           = var.instance_class
  name                     = var.name
  username                 = var.username
  service                  = var.service
  db_user                  = var.db_user
  vpc_id                   = module.vpc.vpc_id
  public_subnet_group_name = module.vpc.public_subnet_group_name
  public_subnet_ids        = module.vpc.public_subnet_ids
  private_subnet_a_id      = module.vpc.private_subnet_a_id
  private_subnet_b_id      = module.vpc.private_subnet_b_id
  lambda_security_group_id = module.lambda.lambda_security_group_id
}

module "lambda" {
  source                             = "./modules/lambda"
  service                            = var.service
  vpc_id                             = module.vpc.vpc_id
  rds_connect_policy_arn             = module.iam.rds_connect_policy_arn
  s3_vpce_prefix_list                = module.s3.s3_vpce_prefix_list
  vpc_endpoint_ssm_security_group_id = module.mysql_db.vpc_endpoint_ssm_security_group_id
  rds_security_group_id              = module.mysql_db.rds_security_group_id
}

module "iam" {
  source         = "./modules/iam"
  region         = var.region
  service        = var.service
  db_user        = var.db_user
  db_resource_id = module.mysql_db.db_resource_id
  iam_user_name  = var.iam_user_name
}

module "s3" {
  source                        = "./modules/s3"
  service                       = var.service
  s3_bucket_names               = var.s3_bucket_names
  event_driven_app_bucket_acl   = var.event_driven_app_bucket_acl
  vpc_id                        = module.vpc.vpc_id
  current_iam_caller_account_id = module.iam.current_iam_caller_account_id
  private_route_table_id        = module.vpc.private_route_table_id
  sqs_arn                       = module.sqs.sqs_arn
}

module "sqs" {
  source                           = "./modules/sqs"
  service                          = var.service
  sqs_name                         = var.sqs_name
  event_driven_app_csv_buckets_arn = module.s3.event_driven_app_csv_buckets_arn
  current_iam_caller_account_id    = module.iam.current_iam_caller_account_id
}
