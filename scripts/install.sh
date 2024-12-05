#!/bin/sh

DOCTL_ACCESS_TOKEN=$1

if [ -z "$DOCTL_ACCESS_TOKEN" ]; then
  echo "Error: DOCTL_ACCESS_TOKEN is not set"
  exit 1
fi

echo "Updating package list and installing dependencies..."
sudo apt-get update -y || { echo "Failed to update package list"; exit 1; }
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

echo "Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker-compose --version

echo "Installing DigitalOcean CLI..."
sudo snap install doctl
sudo snap connect doctl:dot-docker
sudo mkdir -p /root/.config

echo "Logging into DigitalOcean Services..."
sudo doctl auth init --access-token $DOCTL_ACCESS_TOKEN
sudo doctl registry login

echo "Running docker-compose command..."

sudo apt install docker-compose
sudo docker-compose -f /var/local/docker-compose.prod.yaml up --build -d
