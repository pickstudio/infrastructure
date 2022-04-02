## 참고 링크 format
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository

#locals {
#  buddystock_meta = {
#    crew = "pickstudio", // 동연님과 함께 속한 그룹 이름
#    team = "buddystock_rest", // 프로젝트를 진행할는 팀
#    service = "buddystock_rest", // 프로젝트의 서비스 이름
#  }
#
#  repo_name_buddystock_rest = "buddystock_rest" // repo의 이름
#}
#
#resource "aws_ecr_repository" "{local.buddystock_meta.service}_{local.repo_name_buddystock_rest}" {
#  name                 = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
#  image_tag_mutability = "MUTABLE"
#
#  image_scanning_configuration {
#    scan_on_push = true
#  }
#
#  tags = {
#    Crew = local.buddystock_meta.crew
#    Team = local.buddystock_meta.team
#    Service = local.buddystock_meta.service
#    Name = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
#    Repository = "${local.buddystock_meta.service}/${local.repo_name_buddystock_rest}"
#  }
#}
#
#output "{local.buddystock_meta.service}_{local.repo_name_buddystock_rest}" {
#  value = aws_ecr_repository.{local.buddystock_meta.service}_{local.repo_name_buddystock_rest}.repository_url
#}
