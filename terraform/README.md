# Minimal stack duplicated for dev + test (Terraform)

This provisions **two separate environments** (`dev` and `test`) with the same minimal stack:

- **EC2** (Amazon Linux) + **Security Group**
- **Elastic IP** (stable IP per env)
- **Route 53** records:
  - `dev-origin.<root_domain>` / `test-origin.<root_domain>` → A record to the env EIP (CloudFront origin)
  - `dev.<root_domain>` / `test.<root_domain>` → A/ALIAS to CloudFront distribution
- **CloudFront** distribution per env
- **Optional DB**: RDS PostgreSQL per env (disabled by default)

## Prereqs

- AWS credentials with permissions for: EC2, EIP, Route53, ACM, CloudFront, (optional) RDS, Secrets Manager.
- A public Route 53 hosted zone for your domain.

## Configure

From `terraform/`:

```bash
terraform init
```

Set variables (examples):

```bash
export TF_VAR_root_domain="example.com"
# optional if your AWS account has multiple zones with same name
# export TF_VAR_hosted_zone_id="Z123456ABCDEFG"

# lock down SSH to your IP(s)
export TF_VAR_allowed_ssh_cidrs='["203.0.113.10/32"]'

# paste your SSH public key material
export TF_VAR_ssh_public_key="ssh-ed25519 AAAA... you@laptop"
```

Or copy `terraform.tfvars.example` to `terraform.tfvars`.

## Apply

```bash
terraform apply
```

CloudFront + ACM validation can take a while to fully deploy.

## Outputs

After apply, you’ll get:

- `dev_url`, `test_url`: public URLs via CloudFront
- `dev_origin_ip`, `test_origin_ip`: EC2 EIPs (also used by the `*-origin` records)
- `dev_db_secret_arn`, `test_db_secret_arn` (only if DB enabled)

## Notes / tradeoffs (kept minimal)

- This uses the **default VPC** + its subnets for simplicity.
- HTTP (80) to the instance is open to the internet by default (so CloudFront can reach it). Tightening this further typically requires WAF, ALB, or CloudFront-managed origin access patterns.
