terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-other-other-bucket"
}

# Upload a simple file to S3
resource "aws_s3_object" "file_upload" {
  bucket  = aws_s3_bucket.example.bucket
  key     = "hello.txt"
  content = "Hello, World!"
}
