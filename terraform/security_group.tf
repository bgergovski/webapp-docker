resource "aws_security_group" "webapp_lb" {
  vpc_id = aws_vpc.webapp.id
  name   = var.service_name
  tags   = merge(local.tags, { Name : "load-balancer" })
}

resource "aws_security_group" "webapp_ecs" {
  vpc_id = aws_vpc.webapp.id
  tags   = merge(local.tags, { Name : "ecs-task" })
}

resource "aws_security_group_rule" "ingress_load_balancer_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.webapp_lb.id
  to_port           = 80
  cidr_blocks = [
  "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress_load_balancer_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.webapp_lb.id
  to_port           = 443
  cidr_blocks = [
  "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress_ecs_task_elb" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.webapp_ecs.id
  to_port                  = 80
  source_security_group_id = aws_security_group.webapp_lb.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "egress_load_balancer" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
  security_group_id = aws_security_group.webapp_lb.id
}

resource "aws_security_group_rule" "egress_ecs_task" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
  security_group_id = aws_security_group.webapp_ecs.id
}
