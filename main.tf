data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_ping"
  description = "Allow ICMP ping"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_all]
}

# data "aws_instance" "existing" {
#   instance_id = "i-0eada5807efb1c575"
# }


output "ec2_ip" {
  value = aws_instance.web_server.public_ip
}
