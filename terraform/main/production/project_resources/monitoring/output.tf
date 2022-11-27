

output "rds_address" {
  value = aws_db_instance.rds.address
}
output "rds_port" {
  value = aws_db_instance.rds.port
}
output "rds_dialect" {
  value = aws_db_instance.rds.domain
}
output "rds_username" {
  value = aws_db_instance.rds.username
}
output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}
output "rds_arn" {
  value = aws_db_instance.rds.arn
}
output "rds_id" {
  value = aws_db_instance.rds.id
}


#
#output "elasticache_port" {
#  value = aws_db_instance.pickstudio.port
#}
#output "elasticache_dialect" {
#  value = aws_db_instance.pickstudio.domain
#}
#output "elasticache_username" {
#  value = aws_db_instance.pickstudio.username
#}
#output "elasticache_password" {
#  value = aws_db_instance.pickstudio.password
#}
#output "elasticache_db_name" {
#  value = aws_db_instance.pickstudio.db_name
#}