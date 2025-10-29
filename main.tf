module "ec2_web" {
  source        = "./modules/ec2-instance"
  environment   = var.environment
  instance_type = var.instance_type
  ami_id        = var.ami_id
  allowed_ports = var.allowed_ports
  user_data     = templatefile("${path.module}/src/user-data.sh", {})
}

# Output to display instance information
output "instance_public_ip" {
  value       = module.ec2_web.instance_public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_id" {
  value       = module.ec2_web.instance_id
  description = "ID of the EC2 instance"
}

output "hello_world_url" {
  value       = "http://${module.ec2_web.instance_public_ip}/hello.html"
  description = "URL to access the Hello World server"
}
