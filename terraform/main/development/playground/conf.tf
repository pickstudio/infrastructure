terraform {
  required_version = "1.1.7"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/development/playground"
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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/route53"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

data "terraform_remote_state" "subnet_public" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc/subnets/public"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
