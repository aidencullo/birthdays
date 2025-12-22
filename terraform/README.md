# EC2 Nginx Hello World Terraform

This Terraform configuration deploys an EC2 instance running nginx with a simple "Hello World" page.

## Architecture

- **EC2 Instance**: Ubuntu 22.04 LTS (t2.micro by default)
- **Web Server**: Nginx serving a Hello World HTML page
- **Security Group**: Allows HTTP (80), HTTPS (443), and SSH (22) access
- **VPC**: Uses the default VPC in your AWS account

## Prerequisites

1. **Terraform**: Install Terraform >= 1.0
   ```bash
   # macOS
   brew install terraform

   # Linux
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. **AWS Credentials**: Configure AWS credentials
   ```bash
   # Option 1: AWS CLI
   aws configure

   # Option 2: Environment variables
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

## Quick Start

1. **Navigate to terraform directory**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

5. **Access the Hello World page**
   After deployment, Terraform will output the URL. Open it in your browser:
   ```
   http://<instance-public-ip>
   ```

## Configuration Variables

You can customize the deployment by creating a `terraform.tfvars` file:

```hcl
aws_region     = "us-west-2"
environment    = "prod"
instance_type  = "t3.micro"
instance_name  = "my-nginx-server"
```

### Available Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region to deploy resources | `us-east-1` |
| `environment` | Environment name (dev, prod) | `dev` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `instance_name` | Name tag for the EC2 instance | `nginx-hello-world` |
| `allowed_cidr_blocks` | CIDR blocks allowed to access the server | `["0.0.0.0/0"]` |

## Outputs

After deployment, Terraform provides the following outputs:

- `instance_id`: The EC2 instance ID
- `instance_public_ip`: Public IP address of the instance
- `instance_public_dns`: Public DNS name of the instance
- `security_group_id`: Security group ID
- `website_url`: Direct URL to access the Hello World page

## Security Considerations

**WARNING**: The default configuration allows access from anywhere (0.0.0.0/0). For production use:

1. Restrict `allowed_cidr_blocks` to specific IP ranges
2. Remove SSH access if not needed
3. Use a bastion host for SSH access
4. Enable AWS Systems Manager Session Manager instead of SSH

Example of restricted access:
```hcl
allowed_cidr_blocks = ["203.0.113.0/24"]  # Your office IP range
```

## Clean Up

To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

## Troubleshooting

### Instance not accessible

1. Check security group rules:
   ```bash
   aws ec2 describe-security-groups --group-ids <security-group-id>
   ```

2. Verify instance is running:
   ```bash
   aws ec2 describe-instances --instance-ids <instance-id>
   ```

3. Check nginx status (requires SSH access):
   ```bash
   ssh ubuntu@<instance-public-ip>
   sudo systemctl status nginx
   ```

### User data not executing

1. Check user data logs on the instance:
   ```bash
   ssh ubuntu@<instance-public-ip>
   sudo cat /var/log/cloud-init-output.log
   ```

## Cost Estimate

- **t2.micro instance**: ~$8.50/month (AWS Free Tier eligible for 12 months)
- **Data transfer**: Varies based on usage
- **EBS storage (8GB)**: ~$0.80/month

Remember to destroy resources when not in use to avoid unnecessary charges.

## License

This Terraform configuration is provided as-is for educational and development purposes.
