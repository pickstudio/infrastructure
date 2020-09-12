resource "aws_nat_gateway" "nat_a" {
  allocation_id = var.common_vpc_eip_id
  subnet_id     = aws_subnet.private_a.id
}

# resource "aws_nat_gateway" "nat_b" {
#   allocation_id = var.common_vpc_eip_id
#   subnet_id     = aws_subnet.private_b.id
# }

# resource "aws_nat_gateway" "nat_c" {
#   allocation_id = var.common_vpc_eip_id
#   subnet_id     = aws_subnet.private_c.id
# }

resource "aws_route" "private_nat_a" {
  route_table_id         = var.common_vpc_rt_private
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

# resource "aws_route" "private_nat_b" {
#   route_table_id         = var.common_vpc_rt_private
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_b.id
# }

# resource "aws_route" "private_nat_c" {
#   route_table_id         = var.common_vpc_rt_private
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_c.id
# }
