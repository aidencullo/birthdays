terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

variable "bucket_name" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}
