# Terraform + Ansible Web Deploy

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-000000?style=for-the-badge&logo=ansible&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

**Complete Infrastructure as Code solution for automated web server deployment.**  
Terraform creates virtual infrastructure on Proxmox, Ansible configures and deploys web applications.

## 🚀 Features

### **Terraform Infrastructure**
- **VM Provisioning**: Automated creation of virtual machines on Proxmox
- **Network Configuration**: Static IP assignment, DNS, gateway setup
- **Resource Management**: CPU, memory, disk allocation
- **SSH Key Management**: Automatic SSH key generation and distribution
- **Inventory Generation**: Dynamic Ansible inventory creation

### **Ansible Configuration**
- **Web Server Setup**: Nginx installation and configuration
- **Security Hardening**: Firewall rules, service hardening
- **Application Deployment**: Web application deployment
- **Monitoring Setup**: Optional monitoring agent installation
- **Health Checks**: Automated service validation

### **CI/CD Pipeline**
- **GitHub Actions**: Automated testing and deployment
- **Terraform Validation**: Code quality and syntax checking
- **Ansible Linting**: Playbook validation and testing
- **Automated Deployment**: Push-to-deploy workflow

## 📋 Prerequisites

### **Required Tools**
- **Terraform** >= 1.0.0
- **Ansible** >= 2.9.0
- **Proxmox VE** >= 7.0 with API access
- **Git** with GitHub account
- **Make** (optional, for convenience)

### **Proxmox Setup**
1. Create API token in Proxmox:
   - Datacenter → Permissions → API Tokens → Add
2. Prepare VM template:
   - Ubuntu 22.04 Cloud-Init template recommended
3. Ensure sufficient resources:
   - Storage space for VMs
   - Network connectivity

## 🏗️ Architecture

```mermaid
graph TB
    A[GitHub Repository] --> B[GitHub Actions]
    B --> C[Terraform Apply]
    C --> D[Proxmox VE]
    D --> E[Create VMs]
    E --> F[Generate Inventory]
    F --> G[Ansible Playbook]
    G --> H[Configure VMs]
    H --> I[Deploy Application]
    I --> J[Web Servers]
    
    subgraph "Infrastructure Layer"
        D
        E
    end
    
    subgraph "Configuration Layer"
        G
        H
        I
    end
    
    subgraph "Application Layer"
        J
    end
    
    J --> K((Users))
🚀 Quick Start
1. Clone and Setup
bash
git clone https://github.com/your-username/terraform-ansible-web-deploy.git
cd terraform-ansible-web-deploy
2. Configure Variables
bash
# Copy example configuration
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

# Edit with your values
nano terraform/terraform.tfvars
3. Initialize Terraform
bash
make init
# or manually:
cd terraform && terraform init
4. Deploy Infrastructure
bash
make apply
# or manually:
cd terraform && terraform apply
5. Configure Servers
bash
make ansible
# or manually:
cd ansible && ansible-playbook -i inventories/terraform_generated.ini site.yml
6. Verify Deployment
bash
make status
# Check web servers
curl http://<vm-ip-address>:80
📁 Project Structure
text
terraform-ansible-web-deploy/
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output values
│   ├── versions.tf           # Terraform version constraints
│   ├── terraform.tfvars      # Variable values (gitignored)
│   ├── modules/              # Reusable modules
│   │   ├── vm/              # Virtual machine module
│   │   ├── network/         # Network module
│   │   └── security/        # Security module
│   └── ssh_keys/            # Generated SSH keys
├── ansible/                  # Configuration management
│   ├── site.yml             # Main playbook
│   ├── ansible.cfg          # Ansible configuration
│   ├── inventories/         # Dynamic inventory
│   │   ├── production.yml
│   │   ├── staging.yml
│   │   └── terraform_generated.ini
│   ├── group_vars/          # Group variables
│   │   ├── all.yml
│   │   ├── webservers.yml
│   │   └── terraform_generated.yml
│   └── roles/webserver/     # Web server role
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       ├── templates/
│       └── vars/main.yml
├── .github/workflows/       # CI/CD pipelines
│   ├── terraform.yml       # Terraform workflow
│   └── ansible.yml         # Ansible workflow
├── tests/                  # Test scripts
│   ├── terraform_test.sh
│   └── ansible_test.sh
├── docs/                   # Documentation
│   ├── architecture.md
│   ├── usage.md
│   └── testing.md
├── Makefile               # Build automation
├── docker-compose.yml     # Local testing
├── .gitignore            # Git ignore rules
├── .terraformignore      # Terraform ignore rules
└── README.md            # This file
⚙️ Configuration
Terraform Variables
Key variables in terraform.tfvars:

hcl
proxmox_api_url          = "https://pve.example.com:8006/api2/json"
proxmox_api_token_id     = "terraform@pve!token"
proxmox_api_token_secret = "your-secret-token"

vm_count        = 2
vm_ip_addresses = ["192.168.1.100", "192.168.1.101"]
vm_cpu_cores    = 2
vm_memory       = 2048

environment = "production"
Ansible Variables
Group variables in ansible/group_vars/:

yaml
# group_vars/webservers.yml
web_server_port: 80
web_root: /var/www/html
site_title: "My Web Application"
monitoring_enabled: true
🔧 Usage Examples
Complete Deployment
bash
# One command deployment
make all
Only Infrastructure
bash
# Create VMs only
make apply
Only Configuration
bash
# Configure existing VMs
make ansible
Destroy Resources
bash
# Clean up everything
make destroy
Development Workflow
bash
# Validate code
make validate

# Format code
make fmt

# Run tests
make test

# Clean generated files
make clean
🧪 Testing
Terraform Tests
bash
./tests/terraform_test.sh
# Validates: terraform validate, fmt, plan
Ansible Tests
bash
./tests/ansible_test.sh
# Validates: syntax, lint, dry-run
Integration Tests
bash
# Full integration test
make test
📊 Monitoring and Validation
Health Checks
Web server: http://<ip>:80/health

SSH connectivity

Service status (nginx, node_exporter)

Validation Reports
bash
# Generate deployment report
make status

# Check Terraform outputs
cd terraform && terraform output
🔒 Security
Best Practices
SSH key-based authentication only

Firewall rules via UFW

Regular security updates

Limited user permissions

Encrypted secrets in GitHub

Secrets Management
bash
# Store in GitHub Secrets:
# - PROXMOX_API_URL
# - PROXMOX_API_TOKEN_ID  
# - PROXMOX_API_TOKEN_SECRET
🤝 Contributing
Fork the repository

Create feature branch: git checkout -b feature/amazing-feature

Commit changes: git commit -m 'Add amazing feature'

Push to branch: git push origin feature/amazing-feature

Open a Pull Request

Development Setup
bash
# Install pre-commit hooks
pre-commit install

# Run validation
make validate

# Run tests
make test
📄 License
This project is licensed under the MIT License - see LICENSE file for details.

👤 Author
Oleksandr Stryzhenko - Infrastructure/Cloud Engineer

GitHub: @strizhenko

LinkedIn: oleksandr-stryzhenko

Email: strizhenkoalexander@gmail.com

🙏 Acknowledgments
HashiCorp Terraform

Ansible

Proxmox VE

GitHub Actions

📈 Project Status
https://img.shields.io/github/last-commit/strizhenko/terraform-ansible-web-deploy
https://img.shields.io/github/repo-size/strizhenko/terraform-ansible-web-deploy
https://img.shields.io/github/license/strizhenko/terraform-ansible-web-deploy
https://img.shields.io/github/issues/strizhenko/terraform-ansible-web-deploy

Version: 1.0.0
Terraform: >= 1.0.0
Ansible: >= 2.9.0
Proxmox VE: >= 7.0

Part of DevOps portfolio. Check out my other projects for complete infrastructure automation solutions.
