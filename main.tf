resource "aws_instance" "example" {
  ami           = "ami-069f9cce803c015bc"
  instance_type = "t3.micro"
  
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello World" > /tmp/hello.txt
    cat /tmp/hello.txt
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
