resource "aws_instance" "this" {
  ami           = "ami-0254b2d5c4c472488"
  instance_type = "t3.micro"
}
