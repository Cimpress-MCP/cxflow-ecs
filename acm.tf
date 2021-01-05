resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = flatten([var.devdomain])
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "myzone" {
  name = var.dns_zone
}

resource "aws_route53_record" "route53_record" {
   depends_on = [
    aws_acm_certificate.cert
  ]

  allow_overwrite = true
  name = tolist(aws_acm_certificate.cert.domain_validation_options)[count.index].resource_record_name
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[count.index].resource_record_value]
  ttl = 60
  type = tolist(aws_acm_certificate.cert.domain_validation_options)[count.index].resource_record_type
  zone_id = data.aws_route53_zone.myzone.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.route53_record.fqdn]
}
