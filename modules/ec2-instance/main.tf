resource "aws_instance" "this" {
  ami           = "ami-0254b2d5c4c472488"  # valid Amazon Linux 2 AMI
  instance_type = "t3.micro"
}

variable "environment" {
  type    = string
  default = "dev"
}
