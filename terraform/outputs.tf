output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.nginx.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.nginx.id
}

output "website_url" {
  description = "URL to access the Hello World page"
  value       = "http://${aws_instance.nginx.public_ip}"
}
