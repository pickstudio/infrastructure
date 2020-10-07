locals {
  meta = {
    crew     = "pickstudio",
    team     = "platform",
    resource = "ecs",
    env      = "development",
    role     = "cluster",
  }

  github_accounts = "drake-jin,JenYata,Jeontaeyun,pan-dugongman,sthkindacrazy"

  zone = {
    a = data.aws_availability_zone.a.name,
    d = data.aws_availability_zone.d.name,
  }
}


resource "aws_ecs_cluster" "cluster" {
  name = "${local.meta.crew}-${local.meta.env}"
  tags = local.meta
}

resource "aws_ecs_service" "service" {
  name            = "echo"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = 3
  launch_type = "EC2"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${local.zone.a}, ${local.zone.d}]"
  }
}

resource "aws_ecs_task_definition" "td" {
  family                = "service"
  container_definitions = file("./cd.json")

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-northeast-2a, ap-northeast-2d]"
  }
}