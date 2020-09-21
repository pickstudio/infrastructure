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
    b = data.aws_availability_zone.b.name,
    c = data.aws_availability_zone.c.name,
    d = data.aws_availability_zone.d.name,
  }
}

//resource "aws_autoscaling_group" "ec2_asg" {
//  # ... other configuration, including potentially other tags ...
//
//  tag {
//    key                 = "AmazonECSManaged"
//    propagate_at_launch = true
//  }
//}

//resource "aws_ecs_capacity_provider" "test" {
//  name = "test"
//
//  auto_scaling_group_provider {
//    auto_scaling_group_arn         = aws_autoscaling_group.test.arn
//    managed_termination_protection = "ENABLED"
//
//    managed_scaling {
//      maximum_scaling_step_size = 1000
//      minimum_scaling_step_size = 1
//      status                    = "ENABLED"
//      target_capacity           = 10
//    }
//  }
//}

resource "aws_ecs_cluster" "cluster" {
  name = "${local.meta.crew}-${local.meta.env}"
  tags = local.meta
}

resource "aws_ecs_service" "service" {
  name            = "echo"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = 3

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
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}