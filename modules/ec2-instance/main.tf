# Security group to allow HTTP traffic
resource "aws_security_group" "web_server" {
  name        = "${var.environment}-web-server"
}

resource "aws_instance" "web_server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_server.name]
}

