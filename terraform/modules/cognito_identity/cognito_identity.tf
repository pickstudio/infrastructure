resource "aws_cognito_user_pool_client" "web" {
  name = "web"

  user_pool_id = var.user_pool_id
}

resource "aws_cognito_identity_pool" "pickstudio_identity" {
  identity_pool_name               = "pickstudio_identity_${var.stage}"
  allow_unauthenticated_identities = false

  supported_login_providers = {
    "accounts.google.com" = var.google_client_id
  }

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.web.id
    provider_name           = "cognito-idp.${var.region}.amazonaws.com/${var.user_pool_id}"
    server_side_token_check = true
  }
}

resource "aws_cognito_identity_provider" "google_provider" {
  user_pool_id  = var.user_pool_id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes              = "email"
    client_id                     = var.google_client_id
    client_secret                 = var.google_client_secret
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = "true"
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "facebook_provider" {
  user_pool_id  = var.user_pool_id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    authorize_scopes              = "email"
    client_id                     = var.facebook_client_id
    client_secret                 = var.facebook_client_secret
    attributes_url_add_attributes = "true"
  }

  attribute_mapping = {
    email = "email"
  }
}
