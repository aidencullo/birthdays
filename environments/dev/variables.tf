variable "environment" {
  description = "Environment name (e.g., dev, prod)"
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
  description = "GitLab token for accessing repositories"
  type        = string
  sensitive   = true
}

variable "artifact_url" {
  description = "URL for artifacts"
  type        = string
}
