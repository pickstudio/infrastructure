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
