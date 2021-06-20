variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
  type        = string
}

variable "vpc_cidr_block" {}

variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}


variable "private_subnet_1_cidr" {}
variable "private_subnet_2_cidr" {}