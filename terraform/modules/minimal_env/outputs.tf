output "url" {
  value       = "https://${local.app_fqdn}"
  description = "Public URL for this environment (via CloudFront)."
}

output "origin_ip" {
  value       = aws_eip.this.public_ip
  description = "Elastic IP for the origin instance."
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "EC2 instance id."
}

output "db_secret_arn" {
  value       = var.create_db ? aws_secretsmanager_secret.db[0].arn : null
  description = "Secrets Manager secret ARN containing DB connection info (null if DB disabled)."
}

