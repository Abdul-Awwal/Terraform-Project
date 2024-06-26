#!/bin/bash

# Update package index
apt-get update

# Install dependencies
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository for Ubuntu
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update package index again
apt-get update

# Install Docker Engine, Docker CLI, and containerd
apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation by running hello-world container
docker run hello-world

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Optionally, manage Docker as a non-root user
usermod -aG docker $USER

# Start Docker service
systemctl start docker

# Enable Docker to start on boot
systemctl enable docker

echo "Docker and Docker Compose installation completed successfully."
