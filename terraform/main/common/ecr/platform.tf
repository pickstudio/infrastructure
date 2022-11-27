
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
