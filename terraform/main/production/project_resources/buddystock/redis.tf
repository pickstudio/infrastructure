
resource "aws_elasticache_cluster" "redis" {
  cluster_id        = "${local.meta.team}-${local.meta.service_redis}-${local.meta.env}"
  engine            = "redis"
  node_type         = "cache.t3.micro"
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true
  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids = local.security_groups

  lifecycle {
    ignore_changes = [engine_version]
  }

  tags = {
    Name        = "${local.meta.team}-${local.meta.service_redis}-${local.meta.env}"
    Service     = local.meta.service_redis
    Environment = local.meta.env
    Team        = local.meta.team
  }
}


resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "buddystock-redis-subnets-production"
  subnet_ids = local.public_subnets
}