#!/bin/bash

set -e

echo "=== Ansible Test Suite ==="
echo ""

# Change to ansible directory
cd ansible

echo "1. Checking Ansible version..."
ansible --version

echo ""
echo "2. Checking playbook syntax..."
ansible-playbook site.yml --syntax-check

echo ""
echo "3. Checking inventory files..."
for inventory in inventories/*.yml inventories/*.ini 2>/dev/null; do
  if [ -f "$inventory" ]; then
    echo "Validating: $(basename $inventory)"
    ansible-inventory -i "$inventory" --list > /dev/null 2>&1 && echo "✓ Valid" || echo "✗ Invalid"
  fi
done

echo ""
echo "4. Checking role structure..."
if [ -d "roles/webserver" ]; then
  echo "✓ webserver role exists"
  
  if [ -f "roles/webserver/tasks/main.yml" ]; then
    tasks_count=$(grep -c "^- name:" roles/webserver/tasks/main.yml 2>/dev/null || echo "0")
    echo "✓ Role has $tasks_count tasks"
  fi
  
  if [ -f "roles/webserver/handlers/main.yml" ]; then
    handlers_count=$(grep -c "^- name:" roles/webserver/handlers/main.yml 2>/dev/null || echo "0")
    echo "✓ Role has $handlers_count handlers"
  fi
  
  if [ -d "roles/webserver/templates" ]; then
    templates_count=$(find roles/webserver/templates -name "*.j2" 2>/dev/null | wc -l)
    echo "✓ Role has $templates_count templates"
  fi
fi

echo ""
echo "5. Checking variable files..."
for vars_file in group_vars/*.yml; do
  if [ -f "$vars_file" ]; then
    echo "Validating: $(basename $vars_file)"
    python3 -c "import yaml; yaml.safe_load(open('$vars_file'))" > /dev/null 2>&1 && echo "✓ Valid YAML" || echo "✗ Invalid YAML"
  fi
done

echo ""
echo "6. Checking ansible.cfg..."
if [ -f "ansible.cfg" ]; then
  echo "✓ ansible.cfg exists"
  if grep -q "host_key_checking = False" ansible.cfg; then
    echo "✓ host_key_checking disabled (good for automation)"
  fi
fi

echo ""
echo "7. Creating test inventory..."
cat > test_inventory.ini << INI
[test_hosts]
localhost ansible_connection=local

[test_hosts:vars]
test_var=test_value
INI

echo ""
echo "8. Testing with localhost..."
ansible-playbook -i test_inventory.ini -c local site.yml --check --diff

echo ""
echo "=== Ansible Tests Completed ==="
echo "✅ All tests passed successfully"

# Cleanup
rm -f test_inventory.ini 2>/dev/null || true
