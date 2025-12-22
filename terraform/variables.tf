variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "nginx-hello-world"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the web server"
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: Open to internet, restrict in production
}
