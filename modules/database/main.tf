
#creating db subnet group for database
resource "aws_db_subnet_group" "db_subnet" {
    name = "db_subnet_group"
    # subnet_ids = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}"]
    subnet_ids = [var.subnet_pri_1, var.subnet_pri_2]
}



#creating security groups for database

resource "aws_security_group" "database_security_gp" {
  name        = "database_sg"
  description = "allow inbond traffic on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #TODO: Fix to allow only from VPC CIDR
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_database"
  }
}

resource "aws_db_instance" "db_test" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class = "db.t2.small"
  identifier = "newtestdb"
  username = "admin"
  password = "***REMOVED***" # Use password/secret from environment variable
  publicly_accessible = false
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.database_security_gp.id}"]
  skip_final_snapshot = true
}



