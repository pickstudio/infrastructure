locals {
  meta = {
    crew       = "pickstudio",
    team       = "infrastructure",
    service    = "grafana_agent"
    env        = "development",
    repository = "755991664675.dkr.ecr.ap-northeast-2.amazonaws.com/infrastructure/grafana-agent:latest",
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
}


resource "aws_ecs_service" "service" {
  name                               = local.meta.service
  cluster                            = local.ecs_cluster_id
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  task_definition                    = aws_ecs_task_definition.td.arn
  scheduling_strategy                = "REPLICA"

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
    "memory": 512,
    "name": "${local.meta.service}",
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
        "name": "AWS_REGION",
        "value": "ap-northeast-2"
      },
      {
        "name": "CLUSTER_NAME",
        "value": "pickstudio"
      },
      {
        "name": "NAMESPACE_NAME",
        "value": "grafana"
      },
      {
        "name": "CONFIG_DISCOVERY_YAML",
        "value": "/etc/agent/ecs_file_sd.yml"
      }
    ],
    "secrets": [
      {
        "name": "REMOTE_WRITE_PROM_PUSH_DSN",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_PROM_PUSH_DSN"
      },
      {
        "name": "REMOTE_WRITE_PROM_PUSH_USERNAME",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_PROM_PUSH_USERNAME"
      },
      {
        "name": "REMOTE_WRITE_PROM_PUSH_PASSWORD",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_PROM_PUSH_PASSWORD"
      },

      {
        "name": "REMOTE_WRITE_LOKI_PUSH_DSN",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_LOKI_PUSH_DSN"
      },
      {
        "name": "REMOTE_WRITE_LOKI_PUSH_USERNAME",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_LOKI_PUSH_USERNAME"
      },
      {
        "name": "REMOTE_WRITE_LOKI_PUSH_PASSWORD",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_LOKI_PUSH_PASSWORD"
      },

      {
        "name": "REMOTE_WRITE_TEMPO_PUSH_DSN",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_TEMPO_PUSH_DSN"
      },
      {
        "name": "REMOTE_WRITE_TEMPO_PUSH_USERNAME",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_TEMPO_PUSH_USERNAME"
      },
      {
        "name": "REMOTE_WRITE_TEMPO_PUSH_PASSWORD",
        "valueFrom": "arn:aws:ssm:ap-northeast-2:755991664675:parameter/ecs/${local.meta.env}/${local.meta.team}/${local.meta.service}/REMOTE_WRITE_TEMPO_PUSH_PASSWORD"
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
