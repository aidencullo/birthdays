variable "env_name" {
  type        = string
  description = "Environment name (e.g., dev, test)."
}

variable "subdomain" {
  type        = string
  description = "Subdomain for the public entrypoint (e.g., dev => dev.<root_domain>)."
}

variable "root_domain" {
  type        = string
  description = "Root domain in Route53 (e.g., example.com)."
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 hosted zone ID for root_domain."
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

variable "create_db" {
  type        = bool
  description = "Whether to create an RDS instance for this environment."
  default     = false
}

variable "db_engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  default     = "16.3"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}

