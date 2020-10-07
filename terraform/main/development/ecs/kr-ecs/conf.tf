terraform {
  required_version = "0.13.1"

  backend "s3" {
    bucket         = "karrot-search-bucket-prod"
    key            = "search-infrastructure/infrastructure/main/alpha/ap-northeast-2/kr-ecs/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "search-terraform-lock-resource-prod"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    datadog = {
      source = "terraform-providers/datadog"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "aws" {
  version = "2.70.0"
  region  = "ap-northeast-2"
}

provider "datadog" {
  version = "2.12.0"
}
