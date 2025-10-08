resource "aws_instance" "example" {
  ami           = "ami-0ca4d5db4872d0c28"
  instance_type = "t2.micro"
}
