## 참고 링크 format
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
#
#resource "aws_ecr_repository" "{team}-{project_name}" {
#  name                 = "{team}/{project_name}"
#  image_tag_mutability = "MUTABLE"
#
#  image_scanning_configuration {
#    scan_on_push = true
#  }
#
#  tags = {
#    Service = "{service}" # 해당 repo에 직접적으로 연관 있는 서비스  - 픽카서비스
#    Name = "{team}/{project_name}" # github의 프로젝트 이름 - 픽카서비스의 api
#    Crew = "{team}" # 픽카
#    Team = "{team}" # 픽카
#    Repository = "pickstudio/{project_name}"
#  }
#}
#
#output "{team}-{project_name}" {
#  value = aws_ecr_repository.{team}-{project_name}.repository_url
#}