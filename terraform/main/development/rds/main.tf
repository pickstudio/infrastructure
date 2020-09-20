locals {
  service = "pickstudio"
  env     = "development"

  volume_size = 20

  subnet_id = data.terraform_remote_state.subnet_private.outputs.subnet_a_id

  security_groups = [data.terraform_remote_state.vpc.outputs.sg_basic_id]
}

resource "aws_db_instance" "pickstudio" {
  identifier = "${local.service}-${local.env}"

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
    Name       = "${local.service}-${local.env}"
    Service    = local.service
    Environmen = local.env
  }

  final_snapshot_identifier = false # for test
  skip_final_snapshot       = true  # for test
  deletion_protection       = false # for test
  enabled_cloudwatch_logs_exports = [
    "error", "general", "slowquery",
  ]

  vpc_security_group_ids = local.security_groups

  db_subnet_group_name = aws_db_subnet_group.subnets.id
}

resource "aws_db_subnet_group" "subnets" {
  name = "${local.service}-${local.env}"

  subnet_ids = [
    data.terraform_remote_state.subnet_private.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_private.outputs.subnet_b_id,
  ]

  tags = {
    Name       = "${local.service}-${local.env}"
    Service    = local.service
    Environmen = local.env
  }
}
