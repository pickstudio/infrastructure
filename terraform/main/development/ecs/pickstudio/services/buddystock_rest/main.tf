locals {
  meta = {
    crew       = "pickstudio",
    team       = "buddystock",
    service    = "buddystock_rest"
    env        = "development",
    repository = "755991664675.dkr.ecr.ap-northeast-2.amazonaws.com/buddystock/buddystock_rest:latest",
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

  service_port = 40431

  container_port = 8080
  desired_count  = 1
}

data "aws_acm_certificate" "acm" {
  domain   = "*.pickstudio.io"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "listener_tls" {
  load_balancer_arn = local.lb_id
  port              = local.service_port
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
    path = "/health"
    healthy_threshold = 2
    unhealthy_threshold = 5
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
  lifecycle {
    ignore_changes = [task_definition]
  }

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
    "entryPoint": ["java", "-jar", "app.jar", "--spring.profiles.active=dev"],
    "networkMode": "bridge",
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": ${local.container_port}
      }
    ],
    "dockerLabels": {
      "PROMETHEUS_EXPORTER_PORT": "${local.container_port}"
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group" : "/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}",
        "awslogs-region": "ap-northeast-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "secrets": [
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/redis_host-sJYuz8",
        "name": "DEV_REDIS_HOST"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/datasource_url-U6aFr6",
        "name": "DEV_DATASOURCE_URL"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/datasource_username-i0yDPN",
        "name": "DEV_DATASOURCE_USERNAME"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/datasource_password-vvm6XC",
        "name": "DEV_DATASOURCE_PASSWORD"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:production/redis_host-AcWroY",
        "name": "PROD_REDIS_HOST"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:production/datasource_url-3PBYQN",
        "name": "PROD_DATASOURCE_URL"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:production/datasource_username-M16nN4",
        "name": "PROD_DATASOURCE_USERNAME"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:production/datasource_password-fSAEiu",
        "name": "PROD_DATASOURCE_PASSWORD"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/youtube/apikey-V0JXlK",
        "name": "YOUTUBE_SUBSCRIPTION_APIKEY"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:nhn/sms/appkey-PUGzeZ",
        "name": "NHN_SMS_APPKEY"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:nhn/sms/secret-VuiTeA",
        "name": "NHN_SMS_SECRET"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:nhn/sms/sendno-6pXDnc",
        "name": "NHN_SMS_SENDNO"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:JWT_SECRET-y7z4bL",
        "name": "JWT_SECRET"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:production/firebase_secret_key-PyLlSB",
        "name": "PROD_FIREBASE_SECRET_KEY"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:development/firebase_secret_key-RDhXGS",
        "name": "DEV_FIREBASE_SECRET_KEY"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:google_client_id-EEeVlq",
        "name": "GOOGLE_CLIENT_ID"
      },
      {
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:755991664675:secret:google_client_secret-mVynFx",
        "name": "GOOGLE_CLIENT_SECRET"
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
