provider "aws" {
  region  = var.region
}


module "vpc_networking" {
    source = "./modules/networking"
    
    vpc_cidr_block = var.vpc_cidr_block

    public_subnet_1_cidr = var.public_subnet_1_cidr
    public_subnet_2_cidr = var.public_subnet_2_cidr

    private_subnet_1_cidr = var.private_subnet_1_cidr
    private_subnet_2_cidr = var.private_subnet_2_cidr
}

module "database" {
  source = "./modules/database"

  subnet_pub_1 = module.vpc_networking.subnet_pub_1
  subnet_pub_2 = module.vpc_networking.subnet_pub_2
  vpc_id = module.vpc_networking.vpc_id

  subnet_pri_1 = module.vpc_networking.subnet_pri_1
  subnet_pri_2 = module.vpc_networking.subnet_pri_2
}

module "autoscaling" {
  source = "./modules/autoscaling"
  
  vpc_id = module.vpc_networking.vpc_id

  subnet_pub_1 = module.vpc_networking.subnet_pub_1
  subnet_pub_2 = module.vpc_networking.subnet_pub_2

  rds_endpoint = module.database.database_endpoint
}