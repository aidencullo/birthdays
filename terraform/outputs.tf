output "dev_url" {
  value       = module.dev.url
  description = "Dev environment CloudFront URL."
}

output "test_url" {
  value       = module.test.url
  description = "Test environment CloudFront URL."
}

output "dev_origin_ip" {
  value       = module.dev.origin_ip
  description = "Dev EC2 Elastic IP."
}

output "test_origin_ip" {
  value       = module.test.origin_ip
  description = "Test EC2 Elastic IP."
}

output "dev_db_secret_arn" {
  value       = module.dev.db_secret_arn
  description = "Dev DB secret ARN (null if DB disabled)."
}

output "test_db_secret_arn" {
  value       = module.test.db_secret_arn
  description = "Test DB secret ARN (null if DB disabled)."
}

