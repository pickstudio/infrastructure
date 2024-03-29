terraform {
  required_version = "1.1.6"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc/subnets/public"
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

data "terraform_remote_state" "common_vpc" {
  backend = "s3"

  config = {
    bucket  = "pickstudio-infrastructure"
    key     = "terraform/v1/common/vpc"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

data "aws_availability_zone" "a" {
  name = "ap-northeast-2a"
}

data "aws_availability_zone" "b" {
  name = "ap-northeast-2b"
}

data "aws_availability_zone" "c" {
  name = "ap-northeast-2c"
}

data "aws_availability_zone" "d" {
  name = "ap-northeast-2d"
}

