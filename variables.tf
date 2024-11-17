variable "droplet_name" {
  description = "Name of the Droplet"
  type        = string
  default     = "portfolio-v2-server"
}

variable "region" {
  description = "DigitalOcean region to create resources in"
  type        = string
  default     = "lon1"
}

variable "size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "ssh_fingerprint" {
  description = "DigitalOcean SSH Fingerprint"
  type        = string
  sensitive   = true
}

variable "digitalocean_access_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}