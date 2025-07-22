#!/bin/bash

echo "🔄 Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "🐳 Installing Docker..."
sudo apt install -y docker.io

echo "🔧 Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "📦 Pulling Strapi image from Docker Hub..."
docker pull madhand249/strapi-backend:v3

echo "🧹 Removing existing container (if any)..."
docker rm -f strapi-app || true

echo "🚀 Running Strapi container..."
docker run -d \
  --name strapi-app \
  --restart unless-stopped \
  -p 1337:1337 \
  madhand249/strapi-backend:v3

echo "📄 Saving container logs..."
docker logs -f strapi-app > /home/ubuntu/strapi-log.txt 2>&1 &

echo "✅ Strapi deployment complete. Accessible at http://<your-ec2-ip>:1337"
