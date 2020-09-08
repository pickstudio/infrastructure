data "aws_region" "current" {}


locals {
  stage  = "alpha"
  region = data.aws_region.current.name

  user_pool_id = "${local.region}_${var.alpha_cognito_user_pool_id}" # user_pool_id

  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret

  facebook_client_id     = var.facebook_client_id
  facebook_client_secret = var.facebook_client_secret
}

module "pickstudio" {
  source = "../../modules/cognito_identity"

  stage  = local.stage
  region = local.region

  user_pool_id = local.user_pool_id

  google_client_id     = local.google_client_id
  google_client_secret = local.google_client_secret

  facebook_client_id     = local.facebook_client_id
  facebook_client_secret = local.facebook_client_secret
}
