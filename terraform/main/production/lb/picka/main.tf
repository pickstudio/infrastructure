locals {

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = [
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_public.outputs.subnet_d_id
  ]

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
  ]

  meta = {
    crew     = "pickstudio",
    team     = "picka",
    resource = "load balancer",
    env      = "production",
    role     = "lb",
    service  = "picka",
  }
}


resource "aws_lb" "picka" {
  name = "${local.meta.service}-${local.meta.env}"

  internal           = false
  load_balancer_type = "application"
  security_groups    = flatten([local.security_groups, module.alb-sg.sg_id])
  subnets            = local.subnet_ids

  enable_deletion_protection = true

  tags = local.meta
}


module "alb-sg" {
  source = "../../../../modules/sg_public_http_server"

  meta = local.meta

  vpc_id = local.vpc_id
}

