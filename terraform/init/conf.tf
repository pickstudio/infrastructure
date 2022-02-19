terraform {
  required_version = "1.1.6"

  required_providers {
    aws = {
      version = "4.2.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  allowed_account_ids = ["755991664675"]
  region  = "ap-northeast-2"
}
