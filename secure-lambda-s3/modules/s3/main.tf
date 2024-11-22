resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
 
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
  depends_on = [ aws_s3_bucket.s3_bucket ]
}
