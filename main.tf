resource "aws_instance" "web_server" {
  ami                    = "ami-0dc8f589abe99f538"
  instance_type          = "t3.micro"
}

output "ec2_ip" {
  value = aws_instance.web_server.public_ip
}
