output "db_resource_id" {
  value = aws_db_instance.default.resource_id
}
output "rds_security_group_id" {
  value = aws_security_group.db.id
}
output "vpc_endpoint_ssm_security_group_id" {
  value = aws_security_group.vpc_endpoint_ssm.id
}
