resource "aws_s3_bucket" "bucket" {
  bucket = "pickstudio-infrastructure"

  tags = {
    Crew       = "pickstudio"
    Team       = "platform"
    Service    = "infrastructure"
    Repository = "pickstudio/infrastructure"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
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
