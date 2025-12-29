# GitHub Actions Workflow Setup

## Overview

The GitHub Actions workflow automatically deploys your Docker container to EC2 whenever you push to the `main` branch.

**Workflow URL:** https://github.com/aidencullo/birthdays/actions

## Setup Instructions

### 1. Set Up EC2 Instance

Follow the steps in `DEPLOY.md` to create your EC2 instance:
- Amazon Linux 2023 AMI
- t2.micro instance
- Security group: Allow HTTP (80) and SSH (22)
- Download your `.pem` key file

### 2. Configure GitHub Secrets

Go to your repository settings and add these secrets:

**Repository Settings → Secrets and variables → Actions → New repository secret**

Add the following three secrets:

#### `EC2_HOST`
Your EC2 instance's public IP address or DNS name:
```
ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com
```
or
```
54.XXX.XXX.XXX
```

#### `EC2_USER`
The SSH username (for Amazon Linux 2023):
```
ec2-user
```

#### `EC2_SSH_KEY`
Your private key file contents (the entire `.pem` file):
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
[your full private key]
...
-----END RSA PRIVATE KEY-----
```

To get your key contents:
```bash
cat your-key.pem
```

### 3. Trigger Deployment

The workflow runs automatically on every push to `main`:
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

Or trigger it manually:
1. Go to https://github.com/aidencullo/birthdays/actions
2. Click "Deploy to EC2" workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

### 4. Monitor Deployment

1. Go to https://github.com/aidencullo/birthdays/actions
2. Click on the latest workflow run
3. Watch the deployment progress in real-time
4. Check the "Verify deployment" step for the final URL

### 5. Access Your App

After successful deployment, visit:
```
http://YOUR_EC2_PUBLIC_IP
```

## Workflow Details

**File:** `.github/workflows/deploy.yml`

**What it does:**
1. Checks out your code
2. Connects to EC2 via SSH
3. Copies all files to EC2
4. Runs `deploy.sh` to build and start Docker container
5. Verifies deployment with health check

**When it runs:**
- On every push to `main` branch
- Manual trigger via GitHub Actions UI

## Troubleshooting

### SSH Connection Failed
- Verify `EC2_HOST` is correct (check EC2 console for public IP)
- Verify `EC2_SSH_KEY` is the complete private key
- Check EC2 security group allows SSH (port 22) from GitHub IPs

### Deployment Script Failed
- SSH into EC2 manually: `ssh -i your-key.pem ec2-user@YOUR_EC2_IP`
- Check logs: `docker logs birthdays-app`
- Verify Docker is installed: `docker --version`

### App Not Responding
- Check if container is running: `docker ps`
- Check EC2 security group allows HTTP (port 80)
- View container logs: `docker logs birthdays-app`

## Next Steps

- View workflow runs: https://github.com/aidencullo/birthdays/actions
- Edit workflow: `.github/workflows/deploy.yml`
- Manual deployment: See `DEPLOY.md`
