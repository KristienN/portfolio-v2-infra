terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.43.0"
    }
  }

  required_version = "~> 1.9.8"
}

provider "digitalocean" {
  token = var.digitalocean_access_token
}

resource "digitalocean_ssh_key" "portfolio-v2-server" {
  name = "digitalocean_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "portfolio-v2-server" {
  image  = "ubuntu-24-10-x64"
  name   = var.droplet_name
  region = var.region
  size   = var.size
  ssh_keys = [var.ssh_fingerprint]
  tags = ["portfolio-v2", "server"]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "root"
      private_key = file("~/.ssh/id_rsa")
      host = self.ipv4_address
    }

    script = "./scripts/install.sh"
  }
}

resource "digitalocean_firewall" "portfolio-v2-server" {
  name = "portfolio-v2-firewall"

  droplet_ids = [digitalocean_droplet.portfolio-v2-server.id]

  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = ["192.168.1.0/24", "2002:1:2::/48"]
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = "all"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol   = "tcp"
    port_range = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol   = "udp"
    port_range = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}