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

# Upload a file to existing S3 bucket
resource "aws_s3_object" "file_upload" {
  bucket  = "my-other-other-bucket"
  key     = "goodbye.txt"
  content = "Goodbye, World!"

}
