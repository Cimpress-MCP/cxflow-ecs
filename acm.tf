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
  depends_on      = [aws_acm_certificate.cert]
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == "var.dns_zone" ? data.aws_route53_zone.myzone.zone_id : data.aws_route53_zone.myzone.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id

}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record: record.fqdn]
}
