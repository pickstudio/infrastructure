resource "aws_s3_bucket" "context" {
  bucket = "pickstudio-secrets"
  acl    = "private"

  versioning {
    enabled = true
  }
  tags = {
    Service     = "pickstudio"
    Environment = "common"
  }
}
