#creating secuirty groups for load balancer and ec2 instance in autoscaling group


resource "aws_security_group" "lb_ec2_security_gp" {
  name        = "lb_ec2_sg"
  description = "allow inbond traffic on port 22 and 80"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22 
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "TLS from VPC" #TODO: Fix description
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_database" #TODO: Fix tags
  }
}


#creating load balancer

resource "aws_lb" "lb_app" {
  name               = "load-balancer-produnction"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_ec2_security_gp.id]
  subnets            = [var.subnet_pub_1, var.subnet_pub_2]

  


}

#creating target group

resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  

  health_check {
    path = "/health.html"
    port = 80
  }
}

#creating listner of load balancer 

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}



# output "launchfile" {
#   value = templatefile("${path.module}/launch.sh", {endpoint=var.rds_endpoint })
# }

# redering templte for launch conf

data "template_file" "user_data" {
  template = "${file("${path.module}/launch.sh")}"
  vars = {
    endpoint = var.rds_endpoint
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}


#creating lauch confrigation
resource "aws_launch_configuration" "as_conf" {
  name          = "web_launch_coff"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "awskeypair"

  security_groups = ["${aws_security_group.lb_ec2_security_gp.id}"]

  user_data = "${data.template_file.user_data.rendered}"

}

# creating autoscaling group 

resource "aws_autoscaling_group" "bar" {
  name                      = "terraform-auto-scaling"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [var.subnet_pub_1, var.subnet_pub_2]
  target_group_arns         = [aws_lb_target_group.target_group.arn]


}   


data "aws_route53_zone" "selected" {
  name         = "kardekari.xyz"
  
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "kardekari.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.lb_app.dns_name
    zone_id                = aws_lb.lb_app.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}" # Replace with your zone ID
  name    = "www.kardekari.xyz" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.lb_app.dns_name}"]
}