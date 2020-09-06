resource "aws_cognito_user_pool" "pickstudio" {
  name = "pickstudio_${var.stage}"

  auto_verified_attributes = [
    "email"
  ]

  email_verification_message = "Your verification code is [{####}]"
  email_verification_subject = "Your verification code"

  password_policy {
    require_lowercase                = "true"
    require_numbers                  = "true"
    require_symbols                  = "true"
    require_uppercase                = "true"
    minimum_length                   = 8
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }
}
