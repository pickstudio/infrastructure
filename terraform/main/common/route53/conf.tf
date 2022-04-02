terraform {
  required_version = "1.1.7"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/route53"
    encrypt = true

    dynamodb_table = "pickstudio-terraform-lock"
  }
  required_providers {
    aws = {
      version = "4.2.0"
      source  = "hashicorp/aws"
    }
  }
}
