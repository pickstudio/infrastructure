locals {
  vpc = {
    id              = data.terraform_remote_state.common_vpc.outputs.vpc_id,
    ipv4_cidr_block = data.terraform_remote_state.common_vpc.outputs.vpc_ipv4_cidr_block,
    ipv6_cidr_block = data.terraform_remote_state.common_vpc.outputs.vpc_ipv6_cidr_block,
    igw_main_id     = data.terraform_remote_state.common_vpc.outputs.igw_main_id
  }

  zone = {
    a = data.aws_availability_zone.a.name,
    b = data.aws_availability_zone.b.name,
    c = data.aws_availability_zone.c.name,
    d = data.aws_availability_zone.d.name,
  }

  meta = {
    publish  = "public",
    crew     = "pickstudio",
    team     = "platform",
    resource = "subnet"
  }
}

module "public_a" {
  source = "../../../../../modules/vpc/public_subnet"

  az                     = local.zone.a
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.192.0/20"
  # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

  vpc_id      = local.vpc.id
  igw_main_id = local.vpc.igw_main_id
  meta        = local.meta
}

module "public_b" {
  source = "../../../../../modules/vpc/public_subnet"

  az                     = local.zone.b
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.208.0/20"
  # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

  vpc_id      = local.vpc.id
  igw_main_id = local.vpc.igw_main_id
  meta        = local.meta
}

# module "public_c" {
#   source = "../../../../../modules/vpc/public_subnet"

#   az                     = local.zone.c
#   subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.224.0/20"
#   # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

#   vpc_id      = local.vpc.id
#   igw_main_id = local.vpc.igw_main_id
#   meta        = local.meta
# }

# module "public_d" {
#   source = "../../../../../modules/vpc/public_subnet"

#   az                     = local.zone.d
#   subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.240.0/20"
#   # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

#   vpc_id      = local.vpc.id
#   igw_main_id = local.vpc.igw_main_id
#   meta        = local.meta
# }

