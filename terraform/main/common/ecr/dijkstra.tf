locals {
  dijkstra_meta = {
    team = "dijkstra",
    service = "dijkstra",
    crew = "pickstudio"
  }

  repo_name_dijkstra_server = "dijkstra_server"
}

resource "aws_ecr_repository" "dijkstra_dijkstra_rest" {
  name                 = "${local.dijkstra_meta.service}/${local.repo_name_dijkstra_server}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Crew = local.dijkstra_meta.crew
    Team = local.dijkstra_meta.team
    Service = local.dijkstra_meta.service
    Name = "${local.dijkstra_meta.service}/${local.repo_name_dijkstra_server}"
    Repository = "${local.dijkstra_meta.service}/${local.repo_name_dijkstra_server}"
  }
}

output "dijkstra_dijkstra_rest" {
  value = aws_ecr_repository.dijkstra_dijkstra_rest.repository_url
}
