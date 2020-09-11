data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-terraform-state"
    key     = "current/common"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

locals {
  service  = "pickstudio"
  role     = "bastion"
  env      = "common"
  key_name = "pickstudio"

  ami_id        = "ami-01ee1702ff85db24d" # Custom bastion AMI, only pickstudio
  instance_type = "t3.small"
  volume_size   = 32

  max_size         = 1
  min_size         = 1
  desired_capacity = 1

  github_accounts = "drake-jin,JenYata,Jeontaeyun,pan-dugongman,sthkindacrazy"
}

module "bastion" {
  source          = "../../modules/ec2"
  github_accounts = local.github_accounts

  service  = local.service
  role     = local.role
  env      = local.env
  key_name = local.key_name

  ami_id        = local.ami_id
  instance_type = local.instance_type
  volume_size   = local.volume_size

  subnet_id = data.terraform_remote_state.common.outputs.subnet_public_an2a_id

  security_groups = [
    data.terraform_remote_state.common.outputs.sg_basic,
    data.terraform_remote_state.common.outputs.sg_members,
  ]
  associate_public_ip_address = true

  iam_instance_profile_name = aws_iam_instance_profile.profile.name
}
