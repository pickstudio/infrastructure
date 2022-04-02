# route53
output "route53_pickstudio_zone_id" {
  value = aws_route53_zone.pickstudio_io.zone_id
}

output "route53_pickstudio_zone_name" {
  value = aws_route53_zone.pickstudio_io.name
}
