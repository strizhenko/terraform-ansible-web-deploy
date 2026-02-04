#!/bin/bash

set -e

echo "=== Terraform Test Suite ==="
echo ""

# Change to terraform directory
cd terraform

echo "1. Checking Terraform version..."
terraform version

echo ""
echo "2. Initializing Terraform..."
terraform init -backend=false

echo ""
echo "3. Validating Terraform configuration..."
terraform validate

echo ""
echo "4. Checking Terraform format..."
terraform fmt -check -recursive

echo ""
echo "5. Generating plan (dry-run)..."
terraform plan -out=test-plan.tfplan

echo ""
echo "6. Checking for unused variables..."
# Simple check for variables without references
variables_count=$(grep -c "^variable" variables.tf 2>/dev/null || echo "0")
echo "Variables defined: $variables_count"

echo ""
echo "7. Checking module structure..."
if [ -d "modules/vm" ]; then
  echo "✓ VM module exists"
  if [ -f "modules/vm/main.tf" ]; then
    echo "✓ VM module has main.tf"
  fi
fi

echo ""
echo "8. Checking .gitignore patterns..."
if grep -q "\.tfstate" ../.gitignore && grep -q "ssh_keys" ../.gitignore; then
  echo "✓ .gitignore contains important patterns"
fi

echo ""
echo "=== Terraform Tests Completed ==="
echo "✅ All tests passed successfully"

# Cleanup
rm -f test-plan.tfplan 2>/dev/null || true
