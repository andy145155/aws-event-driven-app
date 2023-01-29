# Root variables
variable "region" {
  description = "AWS region"
  type        = string
}
variable "service" {
  type        = string
  description = "Name of the project"
}


# VPC variables
variable "main_vpc_cidr" {
  type        = string
  description = "Main VPC CIDR value"
}
variable "public_subnet_a" {
  type        = string
  description = "CIDR value for public subnet a"
}
variable "private_subnet_a" {
  type        = string
  description = "CIDR value for private subnet a"
}
variable "public_subnet_b" {
  type        = string
  description = "CIDR value for public subnet b"
}
variable "private_subnet_b" {
  type        = string
  description = "CIDR value for private subnet b"
}
variable "dns_support" {
  type        = bool
  description = "Bool value for VPC DNS support"
}
variable "dns_hostnames" {
  type        = bool
  description = "Bool value for VPC DNS hostnames"
}
variable "state" {
  type        = string
  description = "State value for availability zone"
}

# RDS variables
variable "allocated_storage" {
  type        = number
  description = "Storage allow for RDS"
}
variable "engine" {
  type        = string
  description = "Database engine"
}
variable "engine_version" {
  type        = string
  description = "Engine version"
}
variable "instance_class" {
  type        = string
  description = "RDS instance type"
}
variable "name" {
  type        = string
  description = "State value for availability zone"
}
variable "username" {
  type        = string
  description = "State value for availability zone"
}

# S3 buckets variables
variable "event_driven_app_bucket_acl" {}
variable "s3_bucket_names" {
  type        = list(any)
  description = "List of s3 bucket names"
}


# IAM variables 
variable "db_user" {}
variable "iam_user_name" {}

# SQS variables
variable "sqs_name" {

}
