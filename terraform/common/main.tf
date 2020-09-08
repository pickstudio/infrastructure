data "aws_vpc" "pickstudio" {
  id = var.common_vpc_id
}

data "aws_security_group" "basic" {
  id = var.common_vpc_security_grpup_basic
}

data "aws_route53_zone" "pickstudio" {
  name = "pickstudio.io."
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

data "aws_subnet" "pickstudio_private_an2a" {
  id = var.common_vpc_subnet_private_an2a
}

data "aws_subnet" "pickstudio_private_an2b" {
  id = var.common_vpc_subnet_private_an2b
}

data "aws_subnet" "pickstudio_private_an2c" {
  id = var.common_vpc_subnet_private_an2c
}

data "aws_subnet" "pickstudio_public_an2a" {
  id = var.common_vpc_subnet_public_an2a
}

data "aws_subnet" "pickstudio_public_an2b" {
  id = var.common_vpc_subnet_public_an2b
}

data "aws_subnet" "pickstudio_public_an2c" {
  id = var.common_vpc_subnet_public_an2c
}

data "aws_route_table" "pickstudio_public_route_table" {
  route_table_id = var.common_vpc_rt_public
}

data "aws_route_table" "pickstudio_private_route_table" {
  route_table_id = var.common_vpc_rt_private
}
