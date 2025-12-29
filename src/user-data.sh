#!/bin/bash
set -e

# Environment variables from Terraform
GITLAB_TOKEN="${GITLAB_TOKEN}"
ARTIFACT_URL="${ARTIFACT_URL}"
ENVIRONMENT="${ENVIRONMENT}"

# Update system
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Download and run artifact
curl -H "PRIVATE-TOKEN: $GITLAB_TOKEN" -o /tmp/artifact.tar.gz "$ARTIFACT_URL"
cd /tmp
tar -xzf artifact.tar.gz

# Start the application
docker-compose up -d

echo "WaterEye deployment completed for environment: $ENVIRONMENT"
