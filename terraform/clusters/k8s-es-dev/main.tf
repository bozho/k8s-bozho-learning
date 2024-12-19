################################################################################
# Validate inputs
################################################################################



################################################################################


module proxmox-k8s {
  source = "../../modules/proxmox-k8s"

  cluster_name  = "k8s-es-dev"

  control_nodes = {
    first_node_id = 15000
    nodes = [
      {
        pve_node   = "pve-node-25"
        ip_address = "10.20.30.11"
      },
      {
        pve_node   = "pve-node-26"
        ip_address = "10.20.30.12"
      },
      {
        pve_node   = "pve-node-25"
        ip_address = "10.20.30.13"
      }
    ]
  }

  worker_nodes = {
    first_node_id = 16000
    nodes = [
      {
        pve_node   = "pve-node-26"
        ip_address = "10.20.30.14"
      },
      {
        pve_node   = "pve-node-25"
        ip_address = "10.20.30.15"
      },
      {
        pve_node   = "pve-node-26"
        ip_address = "10.20.30.16"
      }
    ]
  }
}
