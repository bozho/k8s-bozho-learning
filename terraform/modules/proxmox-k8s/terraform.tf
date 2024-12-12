terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.68.1"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
    }
  }

  required_version = "~> 1.6.0"
}
