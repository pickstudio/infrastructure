locals {
  meta = {
    service      = "search-ecs"
    env          = "alpha"
    team         = "search"
    country_code = "kr"
    region       = "ap-northeast-2"
  }
  name = "${local.meta.service}-${local.meta.env}-${local.meta.country_code}"
}

data "aws_ssm_parameter" "ami_ecs" {
  name            = "/aws/service/ecs/optimized-ami/amazon-linux-2/amzn2-ami-ecs-hvm-2.0.20200902-x86_64-ebs/image_id"
  with_decryption = true
}

data "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"
}

resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = data.aws_iam_role.ecs_instance_role.id
}

data "template_cloudinit_config" "this" {
  gzip = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/template/cloudinit.yaml", {
      ecs_cluster_name : local.name
    })
  }
}

module "asg" {
  source = "../../../../modules/node/modules/asg"

  name          = local.name
  cluster_name  = local.name
  meta          = local.meta
  ami           = data.aws_ssm_parameter.ami_ecs.value
  min           = 2
  desired       = 2
  max           = 2
  iam_name      = aws_iam_instance_profile.this.name
  instance_type = "t3.large"
  role          = "ecs"
  subnet_ids    = module.infra_common.subnet_ids_nat_alpha_ap_northeast_2
  sg_ids        = [module.infra_common.sg_id_default_alpha_ap_northeast_2]
  key_name      = "search"
  volume_size   = 50
  user_data     = data.template_cloudinit_config.this.rendered
}

resource "aws_ecs_capacity_provider" "this" {
  name = local.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.arn
    //    managed_termination_protection = "ENABLED"
  }
}

resource "aws_ecs_cluster" "this" {
  name               = local.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]
  tags               = local.meta
}
