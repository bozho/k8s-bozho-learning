output "proxmox-k8s" {
  description = "Proxmox k8s module output. Contains sensitive data."
  value       = module.proxmox-k8s
  sensitive   = true
}
