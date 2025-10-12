data "aws_instance" "example" {
  instance_id = "i-0123456789abcdef0"
}

output "public_ip" {
  value = data.aws_instance.example.public_ip
}
