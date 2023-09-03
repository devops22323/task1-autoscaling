#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if curl is installed, and if not, install it
if ! command_exists curl; then
  echo "Installing curl..."
  sudo apt-get update
  sudo apt-get install -y curl
fi

# Check if unzip is installed, and if not, install it
if ! command_exists unzip; then
  echo "Installing unzip..."
  sudo apt-get update
  sudo apt-get install -y unzip
fi


# Install kubectl
if ! command_exists kubectl; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
fi

# Install awscli
if ! command_exists aws; then
  echo "Installing awscli..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  
fi

# Verify installations
echo "kubectl version:"
kubectl version --client

echo "aws version:"
aws --version
