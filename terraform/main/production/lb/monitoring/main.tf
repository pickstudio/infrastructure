locals {
  meta = {
    service    = "monitoring"
    crew       = "pickstudio",
    team       = "platform",
    env        = "production",
    repository = "pickstudio/infrastructure",
  }

  subnet_ids = [
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_public.outputs.subnet_d_id,
  ]

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
    data.terraform_remote_state.vpc.outputs.sg_members_id,
  ]

  public_security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
    data.terraform_remote_state.vpc.outputs.sg_public_for_serving_id,
  ]

  cluster_name = "${local.meta.service}-${local.meta.env}"
}

resource "aws_lb" "lb" {
  name               = "lb-${local.cluster_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.public_security_groups
  subnets            = local.subnet_ids

  enable_deletion_protection = true

  tags = {
    Name        = "lb-${local.cluster_name}"
    Environment = local.meta.env
    Team        = local.meta.team
    Crew        = local.meta.crew
  }
}
