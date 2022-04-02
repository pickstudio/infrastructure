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

  service_port = 40001

  container_port = 80
  desired_count = 1
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = local.lb_id
  port              = local.service_port
  protocol          = "HTTP"

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
}

resource "aws_ecs_service" "service" {
  name                = local.meta.service
  cluster             = local.ecs_cluster_id
  desired_count       = local.desired_count
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 100
  task_definition     = aws_ecs_task_definition.td.arn
  scheduling_strategy = "REPLICA"


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
  family                = "${local.meta.team}_${local.meta.service}_${local.meta.env}"
  container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 1,
    "image": "${local.meta.repository}",
    "memory": 256,
    "name": "${local.meta.service}",
    "networkMode": "bridge",
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": ${local.container_port}
      }
    ]
  }
]
TASK_DEFINITION
}


