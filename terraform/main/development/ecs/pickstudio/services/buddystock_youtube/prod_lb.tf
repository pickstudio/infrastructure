locals {
  lb_production_buddystock_id = data.terraform_remote_state.production_lb_buddystock.outputs.lb_id
}

data "aws_acm_certificate" "buddystock_acm" {
  domain   = "buddystock.kr"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = local.lb_production_buddystock_id
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

resource "aws_lb_listener" "listener_buddystock_tls" {
  load_balancer_arn = local.lb_production_buddystock_id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.buddystock_acm.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.buddystock_tg.arn
  }
}

resource "aws_lb_target_group" "buddystock_tg" {
  target_type = "instance"
  port        = local.container_port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id

  health_check {
    protocol = "HTTP"
    path = "/health"
    healthy_threshold = 5
    unhealthy_threshold = 2
    interval = 30
  }
}
