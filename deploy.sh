#!/bin/bash
set -e

echo "Installing Docker..."
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

echo "Building Docker image..."
docker build -t birthdays-app .

echo "Stopping existing container if running..."
docker stop birthdays-app || true
docker rm birthdays-app || true

echo "Running Docker container..."
docker run -d --name birthdays-app -p 80:5000 --restart unless-stopped birthdays-app

echo "Deployment complete! App is running on port 80"
docker ps
