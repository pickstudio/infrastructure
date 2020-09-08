locals {
  stage = "alpha"
}

module "pickstudio" {
  source = "../../modules/cognito_user_pool"

  stage = local.stage
}
