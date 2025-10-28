resource "aws_instance" "example" {
  ami           = "ami-069f9cce803c015bc"
  instance_type = "t2.micro"
}
