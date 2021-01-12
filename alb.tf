locals {
  # sigh, this is unfortunate.  The ELB name is limited to 32 characters, so we have to lose some info.
  # This is me chopping off part of the name while trying to keep it useful
  short_name = substr(var.name, 0, 32)
}

data "aws_route53_zone" "default" {
  name = var.dns_zone
}

resource "aws_lb" "cxflow" {
  name               = local.short_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_lb_listener" "cxflow" {
  load_balancer_arn = aws_lb.cxflow.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Missing environment in path"
      status_code  = 404
    }
  }
}

resource "aws_route53_record" "vault_elb" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_lb.cxflow.dns_name
    zone_id                = aws_lb.cxflow.zone_id
    evaluate_target_health = true
  }
}
