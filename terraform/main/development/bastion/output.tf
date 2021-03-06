output "bastion_id" {
  value = module.bastion.id
}

output "bastion_endpoint" {
  value = aws_route53_record.endpoint.name
}