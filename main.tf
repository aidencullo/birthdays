resource "aws_instance" "example" {
  ami           = "ami-0b967c22fe917319b" # Amazon Linux 2
  instance_type = "t3.micro"
}