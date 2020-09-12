output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "id" {
  value = aws_instance.bastion.id
}
