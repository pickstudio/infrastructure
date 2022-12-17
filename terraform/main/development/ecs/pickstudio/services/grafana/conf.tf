terraform {
  required_version = "1.1.7"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/development/ecs/pickstudio/services/dijkstra_server"
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

provider "aws" {
  allowed_account_ids = ["755991664675"]
  region              = "ap-northeast-2"
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


data "terraform_remote_state" "development_ecs_pickstudio" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/development/ecs/pickstudio"
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

