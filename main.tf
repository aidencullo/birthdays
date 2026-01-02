terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "birthdays-terraform-state-770064411499"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "birthdays-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              # Update package manager
              yum update -y

              # Install Docker
              amazon-linux-extras install docker -y

              # Start Docker service
              systemctl start docker

              # Enable Docker to start on boot
              systemctl enable docker

              # Run a barebones Docker container (alpine with a simple hello message)
              docker run -d --name barebones-container alpine sleep infinity
              EOF

  user_data_replace_on_change = true
}

output "instance_id" {
  value = aws_instance.main.id
}
