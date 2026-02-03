# Terraform + Ansible Web Server Deployment

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-000000?style=for-the-badge&logo=ansible&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

Infrastructure as Code project that demonstrates provisioning a virtual machine with Terraform and configuring it with Ansible. This project deploys a web server with Nginx on Proxmox VE.

## 🏗️ Architecture
terraform-ansible-web-deploy/
├── terraform/          # Infrastructure definition
│   ├── main.tf         # Proxmox VM resource definition
│   ├── variables.tf    # Input variables
│   └── outputs.tf      # Output values
├── ansible/            # Configuration management
│   ├── playbook.yml    # Main Ansible playbook
│   └── roles/          # Ansible roles (future expansion)
├── .gitignore          # Git ignore rules
└── README.md           # Project documentation

📋 Features
Terraform: Infrastructure as Code for VM provisioning
Ansible: Configuration management and application deployment
Proxmox VE: Virtualization platform support
Nginx: High-performance web server
Modular Design: Easy to extend with additional roles

🚀 Quick Start
Prerequisites
Proxmox VE 7.0+ with API access enabled
Terraform 1.3+ installed
Ansible 2.13+ installed
Git for version control

Step 1: Clone the Repository
git clone https://github.com/strizhenko/terraform-ansible-web-deploy.git
cd terraform-ansible-web-deploy

Step 2: Configure Proxmox API Access
Create an API token in Proxmox:
Datacenter → Permissions → API Tokens → Add
User: terraform@pve
Token ID: terraform-token
Copy the secret

Create terraform/terraform.tfvars:
pm_api_url = "https://your-proxmox-host:8006/api2/json"
pm_api_token_id = "terraform@pve!terraform-token"
pm_api_token_secret = "your-api-token-secret-here"
target_node = "pve"  # Your Proxmox node name
template_name = "ubuntu-2204-cloudinit"  # Existing VM template

Step 3: Initialize and Deploy Infrastructure
cd terraform
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve

Step 4: Configure the VM with Ansible
# Get the VM IP from Terraform output
terraform output -raw vm_ip_address > ../inventory.ini

# Run Ansible playbook
cd ..
ansible-playbook -i inventory.ini ansible/playbook.yml

Step 5: Verify Deployment
Open your browser and navigate to: http://<VM_IP_ADDRESS>

You should see: "Hello from Terraform + Ansible!"

🔧 Configuration
Terraform Variables
Variable	        Description	            Default
pm_api_url	        Proxmox API URL	        -
pm_api_token_id	    API token ID	        -
pm_api_token_secret	API token secret	    -
target_node	        Proxmox node name	    "pve"
template_name	    VM template to clone	"ubuntu-2204-cloudinit"
vm_name	            Virtual machine name	"web-server"
vm_cores	        Number of CPU cores	    2
vm_memory	        Memory in MB	        2048
disk_size	        Disk size in GB	        "20G"

Ansible Configuration
The Ansible playbook performs the following tasks:

Updates package cache
Installs Nginx web server
Configures firewall (UFW)
Deploys a simple HTML page
Enables and starts Nginx service

📁 Project Structure Details
Terraform Configuration (terraform/main.tf)
hcl
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true  # Use only for testing with self-signed certs
}

resource "proxmox_vm_qemu" "web_server" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.template_name
  
  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = var.disk_size
  }
  
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  cores   = var.vm_cores
  memory  = var.vm_memory
  agent   = 1  # Enable QEMU agent
  
  os_type = "cloud-init"
  
  # Cloud-init configuration
  ciuser     = "ubuntu"
  sshkeys    = file("~/.ssh/id_ed25519.pub")
  
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = self.default_ipv4_address
    private_key = file("~/.ssh/id_ed25519")
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3"
    ]
  }
}

Ansible Playbook (ansible/playbook.yml)

- name: Deploy and configure web server
  hosts: all
  become: yes
  gather_facts: yes
  
  tasks:
    - name: Update apt package cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
    
    - name: Install Nginx
      apt:
        name: nginx
        state: present
    
    - name: Configure UFW
      ufw:
        rule: allow
        port: '80'
        proto: tcp
    
    - name: Create web content directory
      file:
        path: /var/www/html
        state: directory
        mode: '0755'
    
    - name: Deploy index.html
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head>
              <title>Terraform + Ansible Deployment</title>
              <style>
                  body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
                  h1 { color: #333; }
                  .info { background: #f4f4f4; padding: 20px; margin: 20px auto; max-width: 600px; border-radius: 5px; }
              </style>
          </head>
          <body>
              <h1>🚀 Successfully Deployed with Terraform + Ansible!</h1>
              <div class="info">
                  <p>This server was automatically provisioned and configured.</p>
                  <p><strong>Technologies used:</strong></p>
                  <ul style="list-style: none; padding: 0;">
                      <li>✅ Terraform for infrastructure provisioning</li>
                      <li>✅ Ansible for configuration management</li>
                      <li>✅ Proxmox VE as virtualization platform</li>
                      <li>✅ Nginx as web server</li>
                  </ul>
              </div>
          </body>
          </html>
        dest: /var/www/html/index.html
        mode: '0644'
    
    - name: Ensure Nginx is running and enabled
      systemd:
        name: nginx
        state: started
        enabled: yes
    
    - name: Display deployment info
      debug:
        msg: "Web server deployed successfully! Access at http://{{ ansible_default_ipv4.address }}"

🧪 Testing
Validate Terraform Configuration
terraform validate
terraform fmt -check

Dry Run Ansible Playbook
ansible-playbook -i inventory.ini ansible/playbook.yml --check --diff

Destroy Infrastructure
terraform destroy -var-file=terraform.tfvars

🔄 CI/CD Integration (Future Enhancement)
This project can be extended with GitHub Actions for automated testing and deployment:

name: Terraform CI
on: [push, pull_request]
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terbrm@v2
      - run: terraform init
      - run: terraform validate
      - run: terraform fmt -check

📈 Monitoring (Future Enhancement)
Plan to add:
Prometheus metrics collection
Grafana dashboard for server metrics
Health check endpoints
Log aggregation with ELK stack

🤝 Contributing
Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

👨‍💻 Author
Oleksandr Stryzhenko - Infrastructure/Cloud Engineer
GitHub: @strizhenko
LinkedIn: oleksandr-stryzhenko
Email: strizhenkoalexander@gmail.com

🙏 Acknowledgments
HashiCorp for Terraform
Red Hat for Ansible
Proxmox Server Solutions GmbH for Proxmox VE
Open source community for invaluable tools and libraries
