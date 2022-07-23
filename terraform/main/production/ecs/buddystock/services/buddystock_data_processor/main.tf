locals {
  meta = {
    crew       = "pickstudio",
    team       = "buddystock",
    service    = "buddystock_data_processor"
    env        = "production",
    repository = "755991664675.dkr.ecr.ap-northeast-2.amazonaws.com/buddystock/buddystock_data_processor:latest",
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

  lb_id          = data.terraform_remote_state.production_lb_buddystock.outputs.lb_id

  ecs_cluster_id = data.terraform_remote_state.production_ecs_pickstudio.outputs.ecs_id
  az_a           = data.aws_availability_zone.a.name
  az_d           = data.aws_availability_zone.d.name

  service_port = 40003
  service_tls_port = 40433

  container_port = 5000
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

data "aws_acm_certificate" "acm" {
  domain   = "buddystock.kr"
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
    container_name   = "${local.meta.service}_http"
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
  family                = "${local.meta.team}_${local.meta.service}_${local.meta.env}"
  task_role_arn      = aws_iam_role.task.arn
  execution_role_arn = aws_iam_role.exec.arn
  tags               = local.meta

  container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 1,
    "image": "${local.meta.repository}",
    "memory": 512,
    "name": "${local.meta.service}_http",
    "entryPoint": ["/app/http_server"],
    "networkMode": "bridge",
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": ${local.container_port}
      }
    ],
    "environment": [
      {
        "name": "ENV",
        "value": "${local.meta.env}"
      },
      {
        "name": "HTTP_SERVER_PORT",
        "value": "${local.container_port}"
      },
      {
        "name": "HTTP_SERVER_TIMEOUT",
        "value": "5s"
      },
      {
        "name": "SERVICE_DATABASE_MAX_IDLE_CONNS",
        "value": "10"
      },
      {
        "name": "SERVICE_DATABASE_MAX_OPEN_CONNS",
        "value": "10"
      }
    ],
    "secrets": [
      {
        "name": "SERVICE_DATABASE_DSN",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/buddystock-data-processor/SERVICE_DATABASE_DSN"
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
  },
  {
    "cpu": 1,
    "image": "${local.meta.repository}",
    "memory": 512,
    "name": "${local.meta.service}_scheduler",
    "entryPoint": ["python", "/app/python/scheduler.py"],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group" : "/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}",
        "awslogs-region": "ap-northeast-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment": [
      {
        "name": "ENV",
        "value": "${local.meta.env}"
      },
      {
        "name": "SERVICE_DATABASE_PORT",
        "value": "3306"
      }
    ],
    "secrets": [
      {
        "name": "SERVICE_DATABASE_HOST",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/buddystock-data-processor/SERVICE_DATABASE_HOST"
      },
      {
        "name": "SERVICE_DATABASE_USER",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/buddystock-data-processor/SERVICE_DATABASE_USER"
      },
      {
        "name": "SERVICE_DATABASE_PASSWORD",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/buddystock-data-processor/SERVICE_DATABASE_PASSWORD"
      },
      {
        "name": "SERVICE_DATABASE_DATABASE",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/buddystock-data-processor/SERVICE_DATABASE_DATABASE"
      }
    ]
  }
]
TASK_DEFINITION
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}"
  retention_in_days = 30
  tags = local.meta
}
