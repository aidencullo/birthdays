output "ec2_ip" {
  value = data.aws_instance.web_server.public_ip
}


