variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-069f9cce803c015bc"
}

variable "allowed_ports" {
  description = "List of ports to allow incoming traffic"
  type        = list(number)
  default     = [80]
}


