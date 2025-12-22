variable "aws_region" {
  type        = string
  description = "Region for EC2/RDS resources."
  default     = "us-west-2"
}

variable "root_domain" {
  type        = string
  description = "Root domain name in Route53 (e.g., example.com)."
}

variable "hosted_zone_id" {
  type        = string
  description = "Optional Route53 Hosted Zone ID to use. If null, we'll look up by name."
  default     = null
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH to the instance."
  default     = []
}

variable "ssh_public_key" {
  type        = string
  description = "Public key material for EC2 SSH access."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "dev_create_db" {
  type        = bool
  description = "Whether to create an RDS instance for dev."
  default     = false
}

variable "test_create_db" {
  type        = bool
  description = "Whether to create an RDS instance for test."
  default     = false
}

