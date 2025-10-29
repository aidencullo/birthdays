provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow SSH and HTTP traffic"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
}