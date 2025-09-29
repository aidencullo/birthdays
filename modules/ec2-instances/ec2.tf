resource "aws_instance" "watereye_web" {
  ami           = "ami-0254b2d5c4c472488"  # valid Amazon Linux 2 AMI
  instance_type = "t3.micro"
}