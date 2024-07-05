resource "aws_acm_certificate" "webapp_elb_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(local.tags)
}

resource "aws_route53_record" "webapp_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.webapp_elb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "webapp_elb_cert" {
  certificate_arn         = aws_acm_certificate.webapp_elb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.webapp_cert_validation : record.fqdn]
}
