terraform {
  required_version = "= 0.13.2"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/development/ecs/pickstudio"
    encrypt = true

    dynamodb_table = "pickstudio-terraform-lock"
  }
}

provider "aws" {
  version = "3.7.0"
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

data "terraform_remote_state" "subnet_public" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc/subnets/public"
    region  = "ap-northeast-2"
    encrypt = true
  }
}


data "aws_availability_zone" "a" {
  name = "ap-northeast-2a"
}

data "aws_availability_zone" "d" {
  name = "ap-northeast-2d"
}

