# terraform/s3.tf

resource "aws_s3_bucket" "nlc_uploads" {
  bucket = "nlc-serverless-raw-uploads-${random_id.id.hex}"
  # Add other configurations like versioning if needed
}

resource "random_id" "id" {
  byte_length = 8
}