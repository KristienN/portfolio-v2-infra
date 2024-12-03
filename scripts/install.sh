#!/bin/sh

DOCTL_ACCESS_TOKEN=$1

if [ -z "$DOCTL_ACCESS_TOKEN" ]; then
  echo "Error: DOCTL_ACCESS_TOKEN is not set"
  exit 1
fi

echo "Updating package list and installing dependencies..."
sudo apt-get update -y || { echo "Failed to update package list"; exit 1; }
sudo apt install apt-transport-https ca-certificates curl -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh


sudo snap install doctl
sudo snap connect doctl:dot-docker
sudo mkdir /root/.config

echo "Logging into Digital Ocean Services"
sudo doctl auth init --access-token $DOCTL_ACCESS_TOKEN
sudo doctl registry login

echo "Pulling latest image"
sudo docker pull registry.digitalocean.com/kristien-docr/portfolio-v2:local || { echo "Failed to pull image"; exit 1; }
sudo docker run --name portfolio-v2 -d -p 80:80 registry.digitalocean.com/kristien-docr/portfolio-v2:local