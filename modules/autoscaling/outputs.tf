output "route_53" {
  value = data.aws_route53_zone.selected
}

output "load_balancer_dns" {
  value = aws_lb.lb_app.dns_name
}