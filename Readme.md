# About Project

+ This project is about creating full working wordpress website using terraform.

+ In  this project we use Aws to  deploy website in cloud.

+ we use bash script to  setup wordpress web site in our aws ec2 instances.

+ This project  followes concept of high availability and scaling up using aws services like  autoscaling and availability zones basically we deploy our project in two different availability zones.




# Infastructure of Project

+ We use terraform [infrastructure as code] in this project so below is image of infrastructure of our code like how we setup this project. 


![Alt text](/terraform-modules.jpg?raw=true "Optional Title")


+ In the image above it shows main module which has 4 files , so first is main.tf in which we provide the provider[aws,azure,gcp] and the region as shown below.

```terraform
provider "aws" {
  region  = var.region
}
```
+ And then we difine modules in which we will use sub modules as shown below

``` terraform 
module "vpc_networking" {
    source = "./modules/networking"
    
}
```
In above example we used submodule[networking] in the main module we difined as "vpc_networking".  we use source to use module which is in modules directory.

+ in variables.tf file we declare  all the variables which we will use.

```terraform
variable "vpc_cidr_block" {}
```

+ in outputs.tf we take output of resourse which we wantto see.

```terrafrom
output "subnet_id" {
  value = module.vpc_networking.subnet_pub_1
}
```

+ in terraform.tfvars file we define variable value which is finnaly used.

```terraform
vpc_cidr_block = "10.0.0.0/16"
```

### Submodules

+ in Submodules like [Netwroking] we define the resources in our case we use aws so we will difine aws resources.
then we use this submodules in our main.tf as shown in main modules example.

```terraform
resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name="Production-VPC"
  }
}
```

in above example we create aws resources which is VPC by giving it neccesary value which required to create vpc.

+ thus we create multiple submodules in our case we create autoscaling,networking and database modules and use them in Root module.

# Deployment process

+ As said before in about project section this project uses aws cloud platform to deploy this project so i will give small overview of how we create aws infra and deploy this wordpress project in aws

+ So first of all we create vpc in [aws] then we create tow subnets in different availability zones then we do all the networking stuff to connect the vpc to internet like routing and creating internet gatway and security groups for the ec2 and database.

+ So when we create 2 subnets we create one private subnet and one public subnet so we can deploy ec2 instances which will act as server in our case and the database in the private subnets for the security reason , beacuse we provide internet access to the public subnet and doesnt provide internet access to the private subnet.

+ Then we will create load balancer so it will divide traffic to diffrent servers.

+ after then we will create autosacling for high availability , which will deploy the new servers when one goes down in case. 

+ To sum it up shortly we create 2 ec2 instances which host our wordpress website and a load balancer which distrubtes traffic between them 2 and a database(RDS) which is connected to our servers (ec2).


# Application deployment 

+ So requirement to deploy this project is aws cli account setup and terraform 

+ first we go to the root of the directory and do terraform plan so you can see terraform shows you all the resoures terraform will create

+ after that you have to do terraform apply so terraform will create all the resources and in output you can see a load balncers dns name so you can copy that link and paste in your web browser and you can see the website is up and runing.