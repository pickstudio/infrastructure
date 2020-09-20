# vpc
output "vpc_id" {
  value = aws_vpc.pickstudio.id
}

output "vpc_arn" {
  value = aws_vpc.pickstudio.arn
}

output "vpc_ipv4_cidr_block" {
  value = aws_vpc.pickstudio.cidr_block
}

output "vpc_ipv6_association_id" {
  value = aws_vpc.pickstudio.ipv6_association_id
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.pickstudio.ipv6_cidr_block
}

output "vpc_main_route_table_id" {
  value = aws_vpc.pickstudio.main_route_table_id
}

output "vpc_owner_id" {
  value = aws_vpc.pickstudio.owner_id
}

output "sg_basic_id" {
  value = aws_security_group.basic.id
}

output "sg_members_id" {
  value = aws_security_group.members.id
}

output "igw_main_id" {
  value = aws_internet_gateway.pickstudio.id
}
