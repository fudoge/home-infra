terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.101.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.3:8006"
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}
