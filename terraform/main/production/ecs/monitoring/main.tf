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

module "asg" {
  source = "../../../../modules/ecs_asg"

  cluster_name = local.cluster_name
  purpose      = "ecs-cluster"
  meta         = local.meta

  subnet_ids      = local.subnet_ids
  security_groups = local.security_groups
  ami_id          = "ami-06f7d9282475cc359" # AWS AMI arm64 built by `./packer`

  scale_min     = 1
  scale_desired = 1
  scale_max     = 1

  instance_type = "t4g.medium"
  volume_size   = 100

  key_name = "pickstudio"
}

resource "aws_ecs_capacity_provider" "ecs_cap_provider" {
  name = aws_ecs_cluster.ecs.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.asg_arn
  }
  depends_on = [
    module.asg
  ]
}


resource "aws_ecs_cluster" "ecs" {
  name = local.cluster_name
  tags = {
    Service     = local.meta.service,
    Crew        = local.meta.crew,
    Team        = local.meta.team,
    Environment = local.meta.env,
    Repository  = local.meta.repository,
  }

  depends_on = [
    module.asg
  ]
}
