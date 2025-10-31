data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
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

data "aws_instance" "web_server" {
  provider    = aws.east
  instance_id = "i-0eada5807efb1c575"
}

resource "aws_network_interface_sg_attachment" "attach_allow_all" {
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = data.aws_instance.web_server.network_interface_id
}



output "ec2_ip" {
  value = data.aws_instance.web_server.public_ip
}
