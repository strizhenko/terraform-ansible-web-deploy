terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.0"
    }
    
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
    
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}
