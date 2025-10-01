resource "aws_instance" "this" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
