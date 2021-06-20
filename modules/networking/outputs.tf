output "subnet_pub_1" {
  value = aws_subnet.module_public_subnet_1.id
}

output "subnet_pub_2" {
  value = aws_subnet.module_public_subnet_2.id
}

output "vpc_id" {
  value = aws_vpc.module_vpc.id
}

output "subnet_pri_1" {
  value = aws_subnet.module_private_subnet_1.id
}

output "subnet_pri_2" {
  value = aws_subnet.module_private_subnet_2.id
}