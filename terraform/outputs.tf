output "vm_details" {
  description = "Details of created VMs"
  value = [
    for i in range(var.vm_count) : {
      name     = module.web_servers.vm_names[i]
      id       = module.web_servers.vm_ids[i]
      ip       = module.web_servers.vm_ip_addresses[i]
      ssh      = "ssh -i ${var.ssh_private_key_path} ${var.ssh_user}@${module.web_servers.vm_ip_addresses[i]}"
    }
  ]
}

output "ssh_private_key_path" {
  description = "Path to generated SSH private key"
  value       = local_file.private_key.filename
  sensitive   = true
}

output "ssh_public_key" {
  description = "Generated SSH public key"
  value       = tls_private_key.ssh_key.public_key_openssh
  sensitive   = true
}

output "ansible_inventory_path" {
  description = "Path to generated Ansible inventory"
  value       = local_file.ansible_inventory_header.filename
}

output "web_server_urls" {
  description = "Web server URLs"
  value = [
    for ip in module.web_servers.vm_ip_addresses : 
    "http://${ip}:${var.web_server_port}"
  ]
}

output "deployment_summary" {
  description = "Deployment summary"
  value = <<-EOT
    ========================================
    Deployment Summary
    ========================================
    Environment: ${var.environment}
    VMs Created: ${var.vm_count}
    
    VMs:
    %{ for i in range(var.vm_count) ~}
    - ${module.web_servers.vm_names[i]} (${module.web_servers.vm_ip_addresses[i]})
    %{ endfor ~}
    
    Next Steps:
    1. SSH to VMs using: ssh -i ${var.ssh_private_key_path} ${var.ssh_user}@<VM_IP>
    2. Run Ansible: cd ansible && ansible-playbook -i inventories/terraform_generated.ini site.yml
    3. Test: curl ${module.web_servers.vm_ip_addresses[0]}:${var.web_server_port}
    
    Files generated:
    - SSH keys: terraform/ssh_keys/
    - Ansible inventory: ansible/inventories/terraform_generated.ini
    - Deployment info: DEPLOYMENT.md
    ========================================
  EOT
}
