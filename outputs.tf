output "load_balancer" {
  value = module.autoscaling.load_balancer_dns
}

output "subnet_id" {
  value = module.vpc_networking.subnet_pub_1
}

# output "db_sub_group_name" {
#   value = module.database.aws_db_subnet_group.db_subnet.id
# }

output "db_sub_group_name" {
  value = module.database.db_subnet_gp_name
}

output "db_security_id" {
  value = module.database.database_security_id
}

output "vpc_id_output" {
  value = module.vpc_networking.vpc_id
}

output "RDS_endpoint" {
  value = module.database.database_endpoint
  
}

output "aws_route_53" {
  value = module.autoscaling.route_53
}


# output "launchfile1" {
#   value = module.autoscaling.launchfile
# }