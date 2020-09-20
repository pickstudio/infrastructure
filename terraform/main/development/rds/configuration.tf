terraform {
  required_version = "= 0.13.2"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/development/rds"
    encrypt = true

    dynamodb_table = "pickstudio-terraform-lock"
  }
}

provider "aws" {
  version = "3.5.0"
  region  = "ap-northeast-2"
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

data "terraform_remote_state" "subnet_private" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc/subnets/private"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
