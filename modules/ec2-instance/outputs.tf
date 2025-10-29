output "instance_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.web_server.id
  description = "ID of the EC2 instance"
}

output "instance_private_ip" {
  value       = aws_instance.web_server.private_ip
  description = "Private IP address of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web_server.id
  description = "ID of the security group"
}


