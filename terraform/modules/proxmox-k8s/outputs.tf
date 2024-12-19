output "initial_user" {
	description = "Initial user's username."
	value       = local.initial_user
}

output "initial_user_ssh_key" {
	description = "Initial user's SSH private key."
	value       = tls_private_key.initial_user_key.private_key_openssh
	sensitive   = true
}
