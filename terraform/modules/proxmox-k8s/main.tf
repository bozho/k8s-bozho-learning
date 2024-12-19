################################################################################
# Validate inputs
################################################################################

resource "null_resource" "validate_control_node_vm_ids" {
  lifecycle {
    precondition {
      condition = (var.control_nodes.first_node_id + length(var.control_nodes.nodes) < var.worker_nodes.first_node_id) || (var.control_nodes.first_node_id > var.worker_nodes.first_node_id + length(var.worker_nodes.nodes))
      error_message = "Control and worker node VM IDs cannot overlap."
    }
  }
}

################################################################################

#locals {
#  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJVI2XkkfTzi7kZ+GnaR++o+MaaFDDpL3wV4dzCcOtmMijhWeMLgldfJNQ9D46UnJe+sixoaKVApCGK2CAwqxY7eMXpkEuuXluXE4FECL816vEcV1RNDAFy+u8tvTPmDe7r3PxoV3qp9g+uZ/8KlytuzP6fZlLXPkKLCYr5OVvC9rc75OYkJP3E76z+2G8UTj6jdCOJT04P3+6oH9+IWHCtTZ3ZB5rKxsrMhNQJtg4HHq49rHf9GC2NxvbLs+vgmyDnRS0OdW8bFIOTAnR42f0JiBolmzyFoa/P+WEQZgl8qCGlj/K3+y/3ZjPWKVLhKYczYSU4Zk1fLtwIQxO3jIv bozho@symplectic.co.uk"
#
#}
#
#
#resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
#  name      = "test-ubuntu"
#  node_name = "pve-node-22"
#  vm_id     = 15000
#
#  cpu {
#    cores        = 4
#    type         = "x86-64-v2-AES"  # recommended for modern CPUs
#  }
#
#  memory {
#    dedicated = 2048
#    floating  = 2048 # set equal to dedicated to enable ballooning
#  }
#
#  network_device {
#    bridge  = "vmbr0"
#    vlan_id = "30"
#  }
#
#  operating_system {
#    type = "l26"
#  }
#
##  lifecycle {
##    ignore_changes = [
##      network_device
##    ]
##  }
#
#  disk {
#    interface    = "scsi0"
#    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
#    datastore_id = "VM_NODE_22"
#    file_format  = "raw"
#    size         = 32
#    cache        = "none"
#    discard      = "on"
#    ssd          = true
#  }
#
#  initialization {
#    datastore_id = "VM_NODE_22"
##    user_account {
##      # do not use this in production, configure your own ssh key instead!
##      username = "bozho"
##      password = "password"
##    }
#
#    ip_config {
#      ipv4 {
#        address = "dhcp"
#      }
#    }
#
#    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id
#  }
#
#  agent {
#    enabled = true
#  }
#}
#
#resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
#  content_type = "iso"
#  datastore_id = "ISO_SHARE"
#  node_name    = "pve-node-22"
#  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
#}
#
#resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
#  content_type = "snippets"
#  datastore_id = "local"
#  node_name    = "pve-node-22"
#
#  source_raw {
#    data      = templatefile("${path.module}/cloud-init-user-data.yaml", { ssh_key = local.ssh_key })
#    file_name = "cloud-init-user-data.yaml"
#  }
#
##  source_raw {
##    data = <<-EOF
###cloud-config
##hostname: bozho-test
##timezone: Europe/Bucharest
##
##package_update: true
##packages:
##  - qemu-guest-agent
##
##users:
##  - name: bozho
##    groups: sudo
##    sudo: ALL=(ALL) NOPASSWD:ALL
##
##power_state:
##    delay: now
##    mode: reboot
##    message: Rebooting after cloud-init completion
##    condition: true
##
##    EOF
##
##    file_name = "cloud-init-user-data.yaml"
##  }
#}
#
#
#
##resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
##  name        = "k8s-ele-search-01"
##  description = "Managed by Terraform"
##  tags        = ["terraform", "ubuntu"]
##
##  node_name = "pve-node-22"
##  vm_id     = 15000
##
##  agent {
##    # read 'Qemu guest agent' section, change to true only when ready
##    enabled = true
##  }
##  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
##  stop_on_destroy = true
##
##  startup {
##    order      = "3"
##    up_delay   = "60"
##    down_delay = "60"
##  }
##
##  cpu {
##    cores        = 4
##    type         = "x86-64-v2-AES"  # recommended for modern CPUs
##  }
##
##  memory {
##    dedicated = 2048
##    floating  = 2048 # set equal to dedicated to enable ballooning
##  }
##
##  disk {
##    datastore_id = "VM_NODE_22"
##    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
##    interface    = "scsi0"
##    file_format = "raw"
##  }
##
##  initialization {
###    datastore_id = "VM_NODE_22"
###    user_data_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
##
###    ip_config {
###      ipv4 {
###        address = "dhcp"
###      }
###    }
###
##    user_account {
##      username = "ubuntu"
##      password = "ubuntu"
###      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
###      password = random_password.ubuntu_vm_password.result
###      username = "ubuntu"
##    }
##
##  }
##
###  network_device {
###    bridge  = "vmbr0"
###    vlan_id = 30
###  }
###
###  operating_system {
###    type = "l26"
###  }
###
###  tpm_state {
###    version = "v2.0"
###  }
###
###  serial_device {}
##}
##
##resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
##  content_type = "iso"
##  datastore_id = "ISO_SHARE"
##  node_name    = "pve-node-22"
##  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
##  file_name    = "ubuntu-22.04.test.iso"
##}
#
#
#
#
#
#
##resource "random_password" "ubuntu_vm_password" {
##  length           = 16
##  override_special = "_%@"
##  special          = true
##}
##
##resource "tls_private_key" "ubuntu_vm_key" {
##  algorithm = "RSA"
##  rsa_bits  = 2048
##}
##
##output "ubuntu_vm_password" {
##  value     = random_password.ubuntu_vm_password.result
##  sensitive = true
##}
##
##output "ubuntu_vm_private_key" {
##  value     = tls_private_key.ubuntu_vm_key.private_key_pem
##  sensitive = true
##}
##
##output "ubuntu_vm_public_key" {
##  value = tls_private_key.ubuntu_vm_key.public_key_openssh
##}
#
#
#
#output "ubuntu_image_id" {
#  value = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
#}
#
#
#
##module "globals" {
##  source  = "app.terraform.io/symplectic/globals/symplectic"
##  version = "~> 1.3.0"
##}
##
### Fetch default tags passed in from the root module.
##data "aws_default_tags" "mirror" {}
##
### We need AWS account ID in several places. Fetch it here.
##data "aws_caller_identity" "account" {}
##
##################################################################################
### Validate inputs
##################################################################################
##
##resource "null_resource" "validate_default_tags_name" {
##  lifecycle {
##    precondition {
##      condition = lookup(data.aws_default_tags.mirror.tags, "Name", null) != null
##      error_message = "Default tags must contain the 'Name' tag."
##    }
##  }
##}
##
##resource "null_resource" "validate_subnet_extension" {
##  lifecycle {
##    precondition {
##      condition = can(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, 0))
##      error_message = "Insufficient address space to extend VPC CIDR ${var.vpc_cidr} prefix by ${var.vpc_subnet_bits}."
##    }
##  }
##}
##
##################################################################################
