resource "aws_s3_bucket" "terraform-state" {
  bucket = "pickstudio-infrastructure"
  acl    = "private"
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
