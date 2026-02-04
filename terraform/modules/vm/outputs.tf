output "vm_ids" {
  description = "List of VM IDs"
  value       = proxmox_vm_qemu.web_server[*].vmid
}

output "vm_names" {
  description = "List of VM names"
  value       = proxmox_vm_qemu.web_server[*].name
}

output "vm_ip_addresses" {
  description = "List of VM IP addresses"
  value       = proxmox_vm_qemu.web_server[*].default_ipv4_address
}

output "ssh_connection_strings" {
  description = "List of SSH connection strings"
  value = [
    for vm in proxmox_vm_qemu.web_server : 
    "ssh -i ${var.ssh_private_key_path} ${var.ssh_user}@${vm.default_ipv4_address}"
  ]
}
