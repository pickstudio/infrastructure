locals {
  vpc = {
    id              = data.terraform_remote_state.common_vpc.outputs.vpc_id,
    ipv4_cidr_block = data.terraform_remote_state.common_vpc.outputs.vpc_ipv4_cidr_block,
    ipv6_cidr_block = data.terraform_remote_state.common_vpc.outputs.vpc_ipv6_cidr_block,
  }

  zone = {
    a = data.aws_availability_zone.a.name,
    b = data.aws_availability_zone.b.name,
    c = data.aws_availability_zone.c.name,
    d = data.aws_availability_zone.d.name,
  }

  meta = {
    publish  = "private",
    crew     = "pickstudio",
    team     = "platform",
    resource = "subnet"
  }
}

module "private_a" {
  source = "../../../../../modules/vpc/private_subnet"

  az                     = local.zone.a
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.0.0/19"
  # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

  vpc_id = local.vpc.id

  meta   = local.meta
}


module "private_b" {
  source = "../../../../../modules/vpc/private_subnet"

  az                     = local.zone.b
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.32.0/19"
  # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

  vpc_id = local.vpc.id

  meta   = local.meta
}

# module "private_c" {
#   source = "../../../../../modules/vpc/private_subnet"

#   az = local.zone.c
#   subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.64.0/19"
#   # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

#   vpc_id = local.vpc.id
# 
#   meta   = local.meta
# }

# module "private_d" {
#   source = "../../../../../modules/vpc/private_subnet"

#   az = local.zone.d
#   subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.96.0/19"
#   # subnet_ipv6_cidr_block = "${substr(local.vpc.ipv6_cidr_block, 0, 16)}00::/58"

#   vpc_id = local.vpc.id
# 
#   meta   = local.meta
# }
