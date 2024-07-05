resource "aws_route53_record" "wepapp" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.webapp_elb.dns_name
    zone_id                = aws_lb.webapp_elb.zone_id
    evaluate_target_health = true
  }
}