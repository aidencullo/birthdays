terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name for the EC2 instance"
  type        = string
}

variable "gitlab_token" {
  description = "GitLab token"
  type        = string
  sensitive   = true
}

variable "artifact_url" {
  description = "Artifact URL"
  type        = string
}

resource "aws_security_group" "watereye" {
  name_prefix = "${var.environment}-watereye-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name        = "${var.environment}-watereye-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "watereye_web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.watereye.id]
  iam_instance_profile   = var.iam_role_name

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Environment variables
              GITLAB_TOKEN="${var.gitlab_token}"
              ARTIFACT_URL="${var.artifact_url}"
              ENVIRONMENT="${var.environment}"

              # Update system
              yum update -y

              # Install Docker
              yum install -y docker
              systemctl start docker
              systemctl enable docker

              # Download and run artifact
              curl -H "PRIVATE-TOKEN: $GITLAB_TOKEN" -o /tmp/artifact.tar.gz "$ARTIFACT_URL"
              cd /tmp
              tar -xzf artifact.tar.gz

              # Start the application
              docker-compose up -d

              echo "WaterEye deployment completed for environment: $ENVIRONMENT"
              EOF

  tags = {
    Name        = "${var.environment}-watereye"
    Environment = var.environment
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.watereye_web.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.watereye_web.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.watereye_web.private_ip
}
