output "db_subnet_gp_name" {
  value = aws_db_subnet_group.db_subnet.name
}

output "database_security_id" {
  value = aws_security_group.database_security_gp.id
}

output "database_endpoint" {
  value = aws_db_instance.db_test.address
}