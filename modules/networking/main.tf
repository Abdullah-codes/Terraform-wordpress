resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name="Production-VPC"
  }
}

resource "aws_subnet" "module_public_subnet_1" {
  cidr_block = var.public_subnet_1_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name="Public-Subnet-1"
  }
}


resource "aws_subnet" "module_public_subnet_2" {
  cidr_block = var.public_subnet_2_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name="Public-Subnet-2"
  }
}

# resource "aws_subnet" "module_public_subnet_3" {
#   cidr_block = var.public_subnet_3_cidr
#   vpc_id = aws_vpc.module_vpc.id
#   availability_zone = "${var.region}c"

#   tags = {
#     Name="Public-Subnet-3"
#   }
# }

resource "aws_subnet" "module_private_subnet_1" {
  cidr_block = var.private_subnet_1_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name="Private-Subnet-1"
  }
}

resource "aws_subnet" "module_private_subnet_2" {
  cidr_block = var.private_subnet_2_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name="Private-Subnet-2"
  }
}

# resource "aws_subnet" "module_private_subnet_3" {
#   cidr_block = var.private_subnet_3_cidr
#   vpc_id = aws_vpc.module_vpc.id
#   availability_zone = "${var.region}c"

#   tags = {
#     Name="Private-Subnet-3"
#   }
# }

#creating route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Public-Route-Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Private-Route-Table"
  }
}


#associating route table to public subnets
resource "aws_route_table_association" "public_subnet_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.module_public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.module_public_subnet_2.id
}


#assosiatig route table to private subnets
resource "aws_route_table_association" "private_subnet_1_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.module_private_subnet_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.module_private_subnet_2.id
}


#creating internet gatway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name="Production-IGW"
  }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

