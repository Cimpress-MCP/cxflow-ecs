data "aws_route53_zone" "myzone" {
  name = var.dns_zone
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = [for environment in keys(var.environments) : "${environment}.${var.domain}"]
  validation_method         = "DNS"
  tags                      = local.all_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  depends_on = [
    aws_acm_certificate.cert
  ]

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.fqdn
}
