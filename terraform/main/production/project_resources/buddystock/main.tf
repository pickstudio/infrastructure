locals {
  volume_size = 200

  subnet_id = data.terraform_remote_state.subnet_public.outputs.subnet_a_id

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_basic_id,
    data.terraform_remote_state.vpc.outputs.sg_members_id,
  ]

  production_rds_buddystock_dbname                 = var.production_rds_buddystock_dbname
  production_rds_buddystock_username              = var.production_rds_buddystock_username
  production_rds_buddystock_password              = var.production_rds_buddystock_password

  meta = {
    team    = "buddystock",
    service_redis = "redis",
    service_mysql = "mysql",
    service_queue = "queue",
    env     = "production",
  }
}

resource "aws_db_instance" "rds" {
  identifier = "${local.meta.team}-${local.meta.service_mysql}-${local.meta.env}"

  publicly_accessible = true

  allocated_storage     = local.volume_size
  max_allocated_storage = 600
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "8.0.28"
  instance_class        = "db.t3.micro"
  db_name               = local.production_rds_buddystock_dbname
  username              = local.production_rds_buddystock_username
  password              = local.production_rds_buddystock_password

  allow_major_version_upgrade = true

  availability_zone = "ap-northeast-2a"

  tags = {
    Name        = "${local.meta.team}-${local.meta.service_mysql}-${local.meta.env}"
    Service     = local.meta.service_mysql
    Environment = local.meta.env
    Team        = local.meta.team
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
  name = "${local.meta.team}-${local.meta.service_mysql}-${local.meta.env}"

  subnet_ids = [
    data.terraform_remote_state.subnet_public.outputs.subnet_a_id,
    data.terraform_remote_state.subnet_public.outputs.subnet_d_id,
  ]

  tags = {
    Name        = "${local.meta.team}-${local.meta.service_mysql}-${local.meta.env}"
    Service     = local.meta.service_mysql
    Environment = local.meta.env
    Team        = local.meta.team
  }
}
