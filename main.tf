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
