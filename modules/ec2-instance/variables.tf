variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "user_data" {
  description = "User data script content"
  type        = string
  default     = ""
}

variable "allowed_ports" {
  description = "List of ports to allow incoming traffic"
  type        = list(number)
  default     = [80]
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

