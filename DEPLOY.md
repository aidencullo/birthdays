# Deploy to AWS EC2

## Quick Start

### 1. Launch EC2 Instance

1. Go to AWS Console > EC2 > Launch Instance
2. Choose **Amazon Linux 2023** AMI (free tier eligible)
3. Instance type: **t2.micro** (free tier eligible)
4. Configure Security Group:
   - Allow SSH (port 22) from your IP
   - Allow HTTP (port 80) from anywhere (0.0.0.0/0)
5. Create or select a key pair (.pem file)
6. Launch instance

### 2. Connect to EC2

```bash
# Make your key file secure
chmod 400 your-key.pem

# SSH into your instance (replace with your public IP)
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 3. Upload Files to EC2

From your local machine:

```bash
# Upload all files to EC2
scp -i your-key.pem -r . ec2-user@YOUR_EC2_PUBLIC_IP:~/birthdays/
```

### 4. Deploy on EC2

SSH into EC2 and run:

```bash
cd ~/birthdays
./deploy.sh
```

### 5. Access Your App

Open your browser and go to:
```
http://YOUR_EC2_PUBLIC_IP
```

You should see "Hello, World!"

## Alternative: One-Command Deploy

After uploading files, you can deploy with:

```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP "cd birthdays && ./deploy.sh"
```

## Updating the App

To update after making changes:

```bash
# From local machine
scp -i your-key.pem -r . ec2-user@YOUR_EC2_PUBLIC_IP:~/birthdays/

# On EC2, rebuild and redeploy
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP "cd birthdays && docker build -t birthdays-app . && docker stop birthdays-app && docker rm birthdays-app && docker run -d --name birthdays-app -p 80:5000 --restart unless-stopped birthdays-app"
```

## Troubleshooting

Check if container is running:
```bash
docker ps
```

View container logs:
```bash
docker logs birthdays-app
```

Restart container:
```bash
docker restart birthdays-app
```
