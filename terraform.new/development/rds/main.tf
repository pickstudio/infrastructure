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
  env      = "development"

  volume_size   = 20

  subnet_id = data.terraform_remote_state.common.outputs.subnet_private_an2a_id

  security_groups = [data.terraform_remote_state.common.outputs.sg_basic]

}

resource "aws_db_instance" "pickstudio" {
  identifier           = "${local.service}-${local.env}"

  allocated_storage     = local.volume_size
  max_allocated_storage = 100
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "8.0.20"
  instance_class        = "db.t2.micro"
  name                  = var.development_rds_pickstudio_dbname
  username              = var.development_rds_pickstudio_username
  password              = var.development_rds_pickstudio_password

  allow_major_version_upgrade = true

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${local.service}-${local.env}"
    Service = local.service
    Environmen = local.env
  }

  final_snapshot_identifier = false # for test
  skip_final_snapshot = true # for test
  deletion_protection = true # for test
  enabled_cloudwatch_logs_exports = [
    "error", "general", "slowquery",
  ]

  vpc_security_group_ids = local.security_groups

  db_subnet_group_name = aws_db_subnet_group.subnets.id
}

resource "aws_db_subnet_group" "subnets" {
  name       = "pickstudio-subnets"
  subnet_ids = [
    data.terraform_remote_state.common.outputs.subnet_private_an2a_id,
    data.terraform_remote_state.common.outputs.subnet_private_an2b_id,
    data.terraform_remote_state.common.outputs.subnet_private_an2c_id,
  ]

  tags = {
    Name = "${local.service}-${local.env}"
    Service = local.service
    Environmen = local.env
  }
}