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
    publish  = "private_nat",
    crew     = "pickstudio",
    team     = "platform",
    resource = "subnet"
  }

  # nat_id = {
  #   a = data.terraform_remote_state.common_subnets_public.outputs.subnet_a_nat_id,
  #   d = data.terraform_remote_state.common_subnets_public.outputs.subnet_d_nat_id,
  # }
}

module "private_a" {
  source = "../../../../../modules/vpc/subnets/private_nat"

  az                     = local.zone.a
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.32.0/21"

  vpc_id = local.vpc.id
  # nat_id = local.nat_id.a

  meta = local.meta
}


module "private_d" {
  source = "../../../../../modules/vpc/subnets/private_nat"

  az                     = local.zone.d
  subnet_ipv4_cidr_block = "${substr(local.vpc.ipv4_cidr_block, 0, 6)}.56.0/21"

  vpc_id = local.vpc.id
  # nat_id = local.nat_id.d

  meta = local.meta
}
