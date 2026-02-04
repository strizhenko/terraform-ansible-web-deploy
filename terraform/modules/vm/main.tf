resource "proxmox_vm_qemu" "web_server" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  full_clone  = true
  agent       = 1
  qemu_os     = "other"
  
  # CPU and memory
  cores   = var.cpu_cores
  sockets = 1
  memory  = var.memory
  
  # Disk configuration
  disk {
    slot     = 0
    size     = var.disk_size
    storage  = var.disk_storage
    type     = "scsi"
    ssd      = 1
    discard  = "on"
  }
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  
  # Cloud-init configuration
  ciuser     = var.ssh_user
  sshkeys    = var.ssh_public_key
  
  nameserver = join(" ", var.nameservers)
  searchdomain = var.domain
  
  ipconfig0 = "ip=${var.ip_addresses[count.index]}/${var.netmask},gw=${var.gateway}"
  
  # Connection for provisioning
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = self.default_ipv4_address
    timeout     = "10m"
  }
  
  # Wait for cloud-init to complete
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait",
      "echo 'Cloud-init completed successfully'"
    ]
  }
  
  # Generate Ansible inventory entry
  provisioner "local-exec" {
    command = <<-EOT
      echo "${self.name} ansible_host=${self.default_ipv4_address} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.ssh_private_key_path}" >> ${var.ansible_inventory_path}
    EOT
  }
  
  lifecycle {
    ignore_changes = [
      network,
      disk,
    ]
  }
  
  tags = var.tags
}
