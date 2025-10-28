# Security group to allow HTTP traffic
resource "aws_security_group" "web_server" {
  name        = "hello-world-web-server"
  description = "Allow HTTP traffic for Hello World server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "HelloWorld-WebServer-SG"
  }
}

resource "aws_instance" "example" {
  ami             = "ami-069f9cce803c015bc"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server.name]
  
  user_data = <<-EOF
    #!/bin/bash
    # Create hello world HTML file
    cat > /tmp/hello.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello World!</h1>
    <p>Welcome to the Hello World server</p>
</body>
</html>
HTML
    
    # Start Python HTTP server on port 80
    cd /tmp
    nohup sudo python3 -m http.server 80 > /dev/null 2>&1 &
  EOF
  
  tags = {
    Name = "HelloWorld-Instance"
  }
}

# Output to display instance information
output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.example.id
  description = "ID of the EC2 instance"
}

output "hello_world_url" {
  value       = "http://${aws_instance.example.public_ip}/hello.html"
  description = "URL to access the Hello World server"
}
