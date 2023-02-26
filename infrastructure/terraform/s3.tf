resource "aws_s3_bucket" "scraper-bucket" {
  bucket = "${local.project}"
}

resource "aws_s3_bucket_acl" "dashbot-acl" {
  bucket = aws_s3_bucket.scraper-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "scraper-bucket-versioning" {
  bucket = aws_s3_bucket.scraper-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}