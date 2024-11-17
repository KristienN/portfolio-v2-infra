output "droplet_ip" {
  description = "Public IPv4 address of the Droplet"
  value       = digitalocean_droplet.portfolio-v2-server.ipv4_address
}