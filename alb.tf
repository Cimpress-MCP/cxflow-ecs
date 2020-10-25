resource "aws_acm_certificate" "cxflow" {
  domain_name       = "cxflow.krypton.vpsvc.com"
  validation_method = "DNS"
}

resource "aws_lb" "ecs-production" {
  name               = "ecs-production"
  subnets            = module.vpc.public_subnets.*.ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.ecs-production.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.cxflow.arn}"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cxflow.arn
  }
}

resource "aws_lb_target_group" "cxflow" {
  name        = "cxflow-alb-tg"
  port        = 443
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
}
