# Take ownership of the default security group and remove the rules (it can't be deleted)
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  vpc_id      = module.vpc.vpc_id
  description = "Controls access to the Application Load Balancer (ALB)"

  ingress {
    description = "GitLab.com is using the IP range 34.74.90.64/28 for traffic from its Web/API fleet."
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["34.74.90.64/28"]
  }

  egress {
    description = "Allow all from ALB"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.all_tags, {
    Name = "${var.name}-alb"
  })
}
