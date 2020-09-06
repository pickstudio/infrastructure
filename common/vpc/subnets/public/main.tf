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

  rt_public_id = data.terraform_remote_state.common.outputs.rt_public_id
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


resource "aws_subnet" "public_a" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_a

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.192.0/20"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}00::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_b

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.208.0/20"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}50::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "public_b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = local.vpc_id
  availability_zone = local.zone_c

  cidr_block = "${substr(local.vpc_cidr_block, 0, 6)}.224.0/20"
  # ipv6_cidr_block                 = "${substr(local.vpc_ipv6_cidr_block, 0, 16)}a0::/58"
  # assign_ipv6_address_on_creation = true

  tags = {
    Name = "public_c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = local.rt_public_id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = local.rt_public_id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = local.rt_public_id
}
