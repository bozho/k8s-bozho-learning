terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.68.1"
    }
  }

  required_version = "~> 1.6.0"
}
