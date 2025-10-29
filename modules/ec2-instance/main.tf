# Security group to allow HTTP traffic
resource "aws_security_group" "web_server" {
  name        = "${var.environment}-web-server"
  description = "Security group for ${var.environment} web server"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.environment}-web-server-sg"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_server.name]

  user_data = var.user_data != "" ? var.user_data : null

  tags = merge(
    {
      Name        = "${var.environment}-web-instance"
      Environment = var.environment
    },
    var.tags
  )
}

