resource "aws_ecr_repository" "infrastructure_prometheus_ecs_discovery" {
  name                 = "infrastructure/prometheus-ecs-discovery"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Crew = "pickstudio"
    Team = "platform"
    Service = "grafana"
    Name = "infrastructure/prometheus-ecs-discovery"
    Repository = "github.com/pickstudio/infrastructure"
  }
}

output "infrastructure_prometheus_ecs_discovery" {
  value = aws_ecr_repository.infrastructure_prometheus_ecs_discovery.repository_url
}

resource "aws_ecr_repository" "infrastructure_grafana" {
  name                 = "infrastructure/grafana"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Crew = "pickstudio"
    Team = "platform"
    Service = "grafana"
    Name = "infrastructure/grafana"
    Repository = "github.com/pickstudio/infrastructure"
  }
}

output "infrastructure_grafana" {
  value = aws_ecr_repository.infrastructure_grafana.repository_url
}
