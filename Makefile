.PHONY: help init plan apply destroy ansible clean validate fmt test all

help:
	@echo "Available commands:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Plan Terraform changes"
	@echo "  apply    - Apply Terraform configuration"
	@echo "  destroy  - Destroy Terraform resources"
	@echo "  ansible  - Run Ansible playbook"
	@echo "  clean    - Clean generated files"
	@echo "  validate - Validate Terraform and Ansible"
	@echo "  fmt      - Format Terraform code"
	@echo "  test     - Run tests"
	@echo "  all      - Complete deployment (init → plan → apply → ansible)"

init:
	@echo "Initializing Terraform..."
	cd terraform && terraform init

plan: init
	@echo "Planning Terraform changes..."
	cd terraform && terraform plan

apply: init
	@echo "Applying Terraform configuration..."
	cd terraform && terraform apply -auto-approve

destroy:
	@echo "Destroying Terraform resources..."
	cd terraform && terraform destroy -auto-approve

ansible:
	@echo "Running Ansible playbook..."
	cd ansible && ansible-playbook -i inventories/terraform_generated.ini site.yml

clean:
	@echo "Cleaning generated files..."
	rm -rf terraform/.terraform terraform/terraform.tfstate* terraform/ssh_keys
	rm -f ansible/inventories/terraform_generated.ini ansible/group_vars/terraform_generated.yml
	rm -f terraform/terraform-proxmox.log DEPLOYMENT.md
	find . -name "*.log" -delete
	find . -name "*.retry" -delete

validate:
	@echo "Validating Terraform..."
	cd terraform && terraform validate
	@echo "Validating Terraform format..."
	cd terraform && terraform fmt -check
	@echo "Validating Ansible syntax..."
	cd ansible && ansible-playbook site.yml --syntax-check

fmt:
	@echo "Formatting Terraform code..."
	cd terraform && terraform fmt -recursive

test:
	@echo "Running tests..."
	./tests/terraform_test.sh
	./tests/ansible_test.sh

all: init apply ansible
	@echo "✅ Complete deployment finished!"
	@echo "Web servers are ready at:"
	@cd terraform && terraform output web_server_urls

# Create SSH keys directory
ssh-keys:
	mkdir -p terraform/ssh_keys
	@echo "SSH keys directory created"

# Generate documentation
docs:
	@echo "Generating documentation..."
	terraform-docs markdown terraform/ > terraform/README.md

# Backup Terraform state
backup:
	@echo "Backing up Terraform state..."
	cp terraform/terraform.tfstate terraform/terraform.tfstate.backup.$(shell date +%Y%m%d_%H%M%S)

# Show deployment status
status:
	@echo "Deployment Status:"
	@if [ -f "terraform/terraform.tfstate" ]; then \
		echo "✅ Terraform state exists"; \
		cd terraform && terraform output deployment_summary 2>/dev/null || echo "⚠️  No active deployment"; \
	else \
		echo "⚠️  No Terraform state found"; \
	fi
	@if [ -f "ansible/inventories/terraform_generated.ini" ]; then \
		echo "✅ Ansible inventory generated"; \
	else \
		echo "⚠️  Ansible inventory not generated"; \
	fi
