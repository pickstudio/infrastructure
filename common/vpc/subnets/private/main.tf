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
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  vpc_cidr_block      = data.terraform_remote_state.common.outputs.vpc_cidr_block
  vpc_ipv6_cidr_block = data.terraform_remote_state.common.outputs.vpc_ipv6_cidr_block

  zone_a = data.aws_availability_zone.a.name
  zone_b = data.aws_availability_zone.b.name
  zone_c = data.aws_availability_zone.c.name

  rt_private_id = data.terraform_remote_state.common.outputs.rt_private_id
}

data "aws_availability_zone" "a" {
  name = "ap-northeast-2a"
}

data "aws_availability_zone" "b" {
  name = "ap-northeast-2b"
}

data "aws_availability_zone" "c" {
  name = "ap-northeast-2c"
}


resource "aws_subnet" "private_a" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_a

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.0.0/18"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}00::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "private_a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_b

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.64.0/18"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}50::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "private_b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_c

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.128.0/18"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}a0::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "private_c"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = local.rt_private_id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = local.rt_private_id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = local.rt_private_id
}
