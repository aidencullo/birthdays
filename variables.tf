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


variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-south-1"
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone domain name (must end with a dot, e.g., example.com.)"
  type        = string
}

variable "record_name" {
  description = "DNS record name relative to the hosted zone (e.g., www)"
  type        = string
  default     = "www"
}

variable "record_ttl" {
  description = "TTL for the DNS record"
  type        = number
  default     = 300
}

