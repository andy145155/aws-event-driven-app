output "vpc_id" {
  value = aws_vpc.event_driven_app.id
}

output "public_subnet_ids" {
  value = aws_db_subnet_group.public_subnet_group.subnet_ids
}

output "public_subnet_group_name" {
  value = aws_db_subnet_group.public_subnet_group.name
}

output "private_subnet_ids" {
  value = aws_db_subnet_group.private_subnet_group.subnet_ids
}

output "private_subnet_group_name" {
  value = aws_db_subnet_group.private_subnet_group.name
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}
output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}
output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}
output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
