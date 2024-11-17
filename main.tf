terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.43.0"
    }
  }

  required_version = "~> 1.9.8"
}

provider "digitalocean" {}

resource "digitalocean_droplet" "portfolio-v2-server" {
  image  = "ubuntu-24-10-x64"
  name   = var.droplet_name
  region = var.region
  size   = var.size
  ssh_keys = [var.ssh_fingerprint]
  tags = ["portfolio-v2", "serer"]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "root"
      host = self.ipv4_address
    }

    inline = [
      "docker pull registry.digitalocean.com/kristien-docr/portfolio-v2:latest",
      "docker run -d -p 80:80 --name portfolio-v2 registry.digitalocean.com/kristien-docr/portfolio-v2:latest"
    ]
  }
}