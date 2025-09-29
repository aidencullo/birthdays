provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0254b2d5c4c472488"  # valid Amazon Linux 2 AMI
  instance_type = "t3.micro"
}
