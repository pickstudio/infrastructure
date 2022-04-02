output "playground_id" {
  value = module.playground_ec2.id
}

output "playground_endpoint" {
  value = aws_route53_record.endpoint.name
}
