resource "aws_s3_bucket" "infrastructure" {
  bucket = "pickstudio-infrastructure"
  acl    = "private"

  tags = {
    Crew    = "pickstudio"
    Team    = "platform"
    Service = "infrastructure"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name = "pickstudio-terraform-lock"

  read_capacity  = 1
  write_capacity = 1

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
