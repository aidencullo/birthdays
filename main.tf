variable "ami" {}
variable "instance_type" { default = "t3.micro" }

resource "aws_instance" "server" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data = <<EOF
#!/bin/bash
echo "hello" > /var/www/html/index.html
nohup busybox httpd -f -p 80 &
EOF

  tags = { Name = "basic-server" }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}