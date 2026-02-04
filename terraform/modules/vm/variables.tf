variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "vm"
}

variable "target_node" {
  description = "Proxmox target node"
  type        = string
}

variable "template_name" {
  description = "VM template name"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size"
  type        = string
  default     = "20G"
}

variable "disk_storage" {
  description = "Storage pool"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ip_addresses" {
  description = "List of IP addresses"
  type        = list(string)
}

variable "gateway" {
  description = "Gateway IP"
  type        = string
}

variable "netmask" {
  description = "Network netmask"
  type        = string
  default     = "24"
}

variable "nameservers" {
  description = "DNS nameservers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "local"
}

variable "ansible_inventory_path" {
  description = "Path to Ansible inventory file"
  type        = string
  default     = "../ansible/inventories/terraform_generated.ini"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
