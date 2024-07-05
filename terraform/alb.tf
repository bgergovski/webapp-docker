resource "aws_lb" "webapp_elb" {
  name               = var.service_name
  internal           = false
  load_balancer_type = "application"
  security_groups = [
  aws_security_group.webapp_lb.id]
  subnets = [
    aws_subnet.webapp_a.id,
    aws_subnet.webapp_b.id
  ]

  tags = merge(local.tags, { Name : "webapp-lb" })
}

resource "aws_lb_target_group" "webapp_ecs" {
  name        = "ecs"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.webapp.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = merge(local.tags, { Name : "webapp-lb" })
}

resource "aws_lb_listener" "webapp_https" {
  load_balancer_arn = aws_lb.webapp_elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.webapp_elb_cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_ecs.arn
  }
}

resource "aws_lb_listener" "webapp_http" {
  load_balancer_arn = aws_lb.webapp_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
