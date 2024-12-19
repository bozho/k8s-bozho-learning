locals {
  vm_cloud_image           = "ISO_SHARE:iso/noble-server-cloudimg-amd64.img"
  control_nodes_map        = { for node_index, node in var.control_nodes.nodes : "${var.cluster_name}${format("-ctrl-%02d", node_index + 1)}" => merge(node, { index = node_index }) }
  worker_nodes_map         = { for node_index, node in var.worker_nodes.nodes  : "${var.cluster_name}${format("-wrk-%02d", node_index + 1)}"  => merge(node, { index = node_index }) }
  control_node_boot_script = file("${path.module}/scripts/cloud-init-first-boot-ctrl.sh")
  worker_node_boot_script  = file("${path.module}/scripts/cloud-init-first-boot-wrk.sh")
  initial_user             = "kubo"
}

resource "proxmox_virtual_environment_pool" "pve_cluster_pool" {
  comment = "${var.cluster_name} k8s cluster node group."
  pool_id = var.cluster_name
}

resource "tls_private_key" "initial_user_key" {
  algorithm = "ED25519"
}

resource "proxmox_virtual_environment_file" "control_node_cloud_init_user_data" {
  for_each = local.control_nodes_map

  content_type = "snippets"
  datastore_id = "test_storage"
  node_name    = each.value.pve_node

  source_raw {
    data      = templatefile("${path.module}/cloud-init-user-data.yaml", { initial_user = local.initial_user, initial_user_ssh_key = tls_private_key.initial_user_key.public_key_openssh, hostname = each.key, node_type = "control", first_boot_script = local.control_node_boot_script })
    file_name = "${each.key}-cloud-init-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "control_node" {
  for_each = local.control_nodes_map

  name      = each.key
  node_name = each.value.pve_node
  vm_id     = var.control_nodes.first_node_id + each.value.index
  pool_id   = proxmox_virtual_environment_pool.pve_cluster_pool.id

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = "30"
  }

  operating_system {
    type = "l26"
  }

  disk {
    interface    = "scsi0"
    file_id      = local.vm_cloud_image
    datastore_id = "RBD_POOL"
    file_format  = "raw"
    size         = 32
    cache        = "none"
    discard      = "on"
    ssd          = true
  }

  initialization {
    datastore_id = "RBD_POOL"

    dns {
      domain  = "symplectic.internal"
      servers = [
        "10.20.30.8",
        "10.20.30.9",
        "1.1.1.1"
      ]
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = "10.20.30.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.control_node_cloud_init_user_data[each.key].id
  }

  agent {
    enabled = true
  }

  tags = [
    "terraform",
    "k8s",
    var.cluster_name,
    "control-node"
  ]

  lifecycle {
    ignore_changes = [
      # Ignore VM migrations.
      node_name,
      # Ignore cloud-init user file changes.
      initialization[0].user_data_file_id
    ]
  }
}

resource "proxmox_virtual_environment_file" "worker_node_cloud_init_user_data" {
  for_each = local.worker_nodes_map

  content_type = "snippets"
  datastore_id = "test_storage"
  node_name    = each.value.pve_node

  source_raw {
    data      = templatefile("${path.module}/cloud-init-user-data.yaml", { initial_user = local.initial_user, initial_user_ssh_key = tls_private_key.initial_user_key.public_key_openssh, hostname = each.key, node_type = "worker", first_boot_script = local.worker_node_boot_script})
    file_name = "${each.key}-cloud-init-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "worker_node" {
  for_each = local.worker_nodes_map

  name      = each.key
  node_name = each.value.pve_node
  vm_id     = var.worker_nodes.first_node_id + each.value.index
  pool_id   = proxmox_virtual_environment_pool.pve_cluster_pool.id

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 4096
    floating  = 4096 # set equal to dedicated to enable ballooning
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = "30"
  }

  operating_system {
    type = "l26"
  }

  disk {
    interface    = "scsi0"
    file_id      = local.vm_cloud_image
    datastore_id = "RBD_POOL"
    file_format  = "raw"
    size         = 32
    cache        = "none"
    discard      = "on"
    ssd          = true
  }

  disk {
    interface    = "scsi1"
    datastore_id = "RBD_POOL"
    file_format  = "raw"
    size         = 50
    cache        = "none"
    discard      = "on"
    ssd          = true
  }

  initialization {
    datastore_id = "RBD_POOL"

    dns {
      domain  = "symplectic.internal"
      servers = [
        "10.20.30.8",
        "10.20.30.9",
        "1.1.1.1"
      ]
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = "10.20.30.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.worker_node_cloud_init_user_data[each.key].id
  }

  agent {
    enabled = true
  }

  tags = [
    "terraform",
    "k8s",
    var.cluster_name,
    "worker-node",
    "instance-storage"
  ]

  lifecycle {
    ignore_changes = [
      # Ignore VM migrations.
      node_name,
      # Ignore cloud-init user file changes.
      initialization[0].user_data_file_id
    ]
  }
}
