# Birthdays

## EC2 User Data Setup

This repository contains Terraform configuration to create an AWS EC2 instance with a simple user-data script.

### Files

- `user-data.sh` - A bash script that runs on EC2 instance startup and prints "Hello World"
- `main.tf` - Terraform configuration for creating an EC2 instance
- `terraform.tfvars.example` - Example variables file

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured (via AWS CLI or environment variables)
- (Optional) An AWS EC2 key pair for SSH access

### Usage

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **(Optional) Customize variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your preferred values
   ```

3. **Plan the deployment:**
   ```bash
   terraform plan
   ```

4. **Apply the configuration:**
   ```bash
   terraform apply
   ```

5. **View outputs:**
   After successful deployment, Terraform will output:
   - Instance ID
   - Public IP address
   - Public DNS name

6. **Verify the user-data script:**
   The user-data script runs automatically on instance startup. To verify it ran:
   ```bash
   # SSH into the instance
   ssh -i your-key.pem ec2-user@<instance-public-ip>

   # Check the cloud-init logs
   sudo cat /var/log/cloud-init-output.log | grep "Hello World"
   ```

7. **Destroy resources when done:**
   ```bash
   terraform destroy
   ```

### Configuration Variables

- `aws_region` - AWS region (default: us-east-1)
- `instance_type` - EC2 instance type (default: t2.micro)
- `ami_id` - AMI ID for Amazon Linux 2023 (default: us-east-1 AMI)
- `key_name` - SSH key pair name (optional)

### Security

The configuration creates a security group that allows:
- Inbound SSH (port 22) from anywhere
- All outbound traffic

**Note:** For production use, restrict the SSH CIDR block to your IP address.
