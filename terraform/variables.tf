# Proxmox connection variables
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_target_node" {
  description = "Proxmox target node name"
  type        = string
  default     = "pve"
}

# VM configuration variables
variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "web-server"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "vm_template_name" {
  description = "Name of the VM template to clone"
  type        = string
  default     = "ubuntu-22.04-cloudinit"
}

variable "vm_cpu_cores" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB per VM"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = "20G"
}

variable "vm_disk_storage" {
  description = "Storage pool name"
  type        = string
  default     = "local-lvm"
}

# Network variables
variable "network_bridge" {
  description = "Network bridge interface"
  type        = string
  default     = "vmbr0"
}

variable "vm_ip_addresses" {
  description = "List of static IP addresses for VMs"
  type        = list(string)
  default     = ["192.168.1.100", "192.168.1.101"]
}

variable "vm_gateway" {
  description = "Gateway IP address"
  type        = string
  default     = "192.168.1.1"
}

variable "vm_nameservers" {
  description = "DNS nameservers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

# SSH variables
variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# Application variables
variable "web_server_port" {
  description = "Web server port"
  type        = number
  default     = 80
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "terraform-ansible-web-deploy"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
