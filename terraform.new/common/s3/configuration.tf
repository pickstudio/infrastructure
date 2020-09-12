terraform {
  required_version = "= 0.13.2"

  backend "s3" {
    region = "ap-northeast-2"

    bucket  = "pickstudio-terraform-state"
    key     = "current/common/s3"
    encrypt = true

    dynamodb_table = "pickstudio-terraform-lock"
  }
}

provider "aws" {
  version = "3.5.0"
  region  = "ap-northeast-2"
}
