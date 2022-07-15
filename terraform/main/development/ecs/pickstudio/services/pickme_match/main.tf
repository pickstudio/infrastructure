locals {
  meta = {
    crew       = "pickstudio",
    team       = "pickme",
    service    = "pickme_match"
    env        = "development",
    repository = "755991664675.dkr.ecr.ap-northeast-2.amazonaws.com/pickme/pickme-match:latest",
  }

  subnet_ids = [
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
  ]

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
    data.terraform_remote_state.vpc.outputs.sg_members_id,
  ]
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  lb_id          = data.terraform_remote_state.development_ecs_pickstudio.outputs.lb_id
  ecs_cluster_id = data.terraform_remote_state.development_ecs_pickstudio.outputs.ecs_id
  az_a           = data.aws_availability_zone.a.name
  az_d           = data.aws_availability_zone.d.name

  service_port = 13000
  service_tls_port = 13431

  container_port = 3000
  desired_count  = 1
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = local.lb_id
  port              = local.service_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = local.service_tls_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_acm_certificate" "acm" {
  domain   = "*.pickstudio.io"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "listener_tls" {
  load_balancer_arn = local.lb_id
  port              = local.service_tls_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  target_type = "instance"
  port        = local.container_port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id

  health_check {
    protocol = "HTTP"
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    interval = 30
  }
}

resource "aws_ecs_service" "service" {
  name                               = local.meta.service
  cluster                            = local.ecs_cluster_id
  desired_count                      = local.desired_count
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  task_definition                    = aws_ecs_task_definition.td.arn
  scheduling_strategy                = "REPLICA"


  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = local.meta.service
    container_port   = local.container_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${local.az_a}, ${local.az_d}]"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
#  lifecycle {
#    ignore_changes = [task_definition]
#  }

  depends_on = [aws_ecs_task_definition.td]
}

resource "aws_ecs_task_definition" "td" {
  family             = "${local.meta.team}_${local.meta.service}_${local.meta.env}"
  task_role_arn      = aws_iam_role.task.arn
  execution_role_arn = aws_iam_role.exec.arn
  tags               = local.meta

  container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 1,
    "image": "${local.meta.repository}",
    "memory": 1024,
    "name": "${local.meta.service}",
    "command": ["yarn","start"],
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": ${local.container_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group" : "/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}",
        "awslogs-region": "ap-northeast-2",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}"
  retention_in_days = 30
  tags = local.meta
}
