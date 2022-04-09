locals {
  buddystock_meta = {
    team = "buddystock",
    service = "buddystock",
    crew = "pickstudio"
  }

  repo_name_buddystock_rest = "buddystock_rest"
  repo_name_buddystock_youtube = "buddystock_youtube"
}

resource "aws_ecr_repository" "buddystock_buddystock_rest" {
  name                 = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Crew = local.buddystock_meta.crew
    Team = local.buddystock_meta.team
    Service = local.buddystock_meta.service
    Name = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
    Repository = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
  }
}

output "buddystock_buddystock_rest" {
  value = aws_ecr_repository.buddystock_buddystock_rest.repository_url
}

resource "aws_ecr_repository" "buddystock_buddystock_youtube" {
  name                 = "${local.buddystock_meta.service}/${local.repo_name_buddystock_youtube}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Crew = local.buddystock_meta.crew
    Team = local.buddystock_meta.team
    Service = local.buddystock_meta.service
    Name = "${local.buddystock_meta.service}/${local.repo_name_buddystock_youtube}"
    Repository = "${local.buddystock_meta.service}/${local.repo_name_buddystock_youtube}"
  }
}

output "buddystock_buddystock_youtube" {
  value = aws_ecr_repository.buddystock_buddystock_youtube.repository_url
}
