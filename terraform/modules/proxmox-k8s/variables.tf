variable "cluster_name" {
  description = "Cluster name. Used as prefix for node names."
  type        = string
  nullable    = false
}

variable "control_nodes" {
  description = "Control nodes settings."
  type = object({
    first_node_id = number,
    nodes = list(object({
      pve_node   = string
      ip_address = string
    }))
  })
  nullable = false

  validation {
    condition = var.control_nodes.first_node_id > 0
    # Individual property and cross-variable validations are performed in main.tf.
    error_message = "Validation failed. first_node_id must be a number greater than 0."
  }
}

variable "worker_nodes" {
  description = "Worker nodes settings."
  type = object({
    first_node_id = number,
    nodes = list(object({
      pve_node   = string
      ip_address = string
    }))
  })
  nullable = false

  validation {
    condition = var.worker_nodes.first_node_id > 0
    # Individual property and cross-variable validations are performed in main.tf.
    error_message = "Validation failed. first_node_id must be a number greater than 0."
  }
}

#variable "first_control_node_vm_id" {
#  description = "Starting value for control nodes VM IDs."
#  type        = number
#  nullable    = false
#}
#
#variable "control_nodes" {
#  description = "The number of cluster control nodes."
#  type        = number
#  nullable    = false
#  default     = 3
#}
#
#variable "first_worker_node_vm_id" {
#  description = "Starting value for worker nodes VM IDs."
#  type        = number
#  nullable    = false
#}
#
#variable "worker_nodes" {
#  description = "The number of cluster control nodes."
#  type        = number
#  nullable    = false
#  default     = 3
#}
#