# backend.tf
terraform {
  backend "s3" {
    bucket = "gitesh-nlc-serverless-tfstate-2025" # <-- IMPORTANT: Change this to a unique name
    key    = "serverless-platform/terraform.tfstate"
    region = "ap-south-1" # Or your preferred region
  }
}