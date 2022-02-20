locals {
  meta = {
    service  = "pickstudio"
    crew     = "pickstudio",
    team     = "platform",
    resource = "ecs",
    env      = "development",
    role     = "cluster",
  }

  subnet_ids = [
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
  ]

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
    data.terraform_remote_state.vpc.outputs.sg_members_id,
  ]

  cluster_name = "${local.meta.service}-${local.meta.role}-${local.meta.resource}-${local.meta.env}"
}

data "aws_ssm_parameter" "ami_ecs" {
  name            = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
  with_decryption = true
}

module "asg" {
  source = "../../../../modules/ecs_asg"

  cluster_name = local.cluster_name
  meta         = local.meta

  subnet_ids      = local.subnet_ids
  security_groups = local.security_groups
  ami_id          = data.aws_ssm_parameter.ami_ecs.value

  scale_min     = 0
  scale_desired = 0
  scale_max     = 0
  instance_type = "t3.medium"
  volume_size   = 50

  key_name = "pickstudio"
}

resource "aws_ecs_capacity_provider" "ecs_cap_provider" {
  name = local.cluster_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.asg_arn
    //    managed_termination_protection = "ENABLED"
  }
}

resource "aws_ecs_cluster" "ecs" {
  name               = local.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cap_provider.name]
  tags               = local.meta
}
