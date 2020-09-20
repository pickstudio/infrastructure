output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "subnet_rtb_id" {
  value = aws_route_table.rtb.id
}
