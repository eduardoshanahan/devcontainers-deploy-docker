#!/bin/bash
# =============================================================================
# ANSIBLE RUNNER SCRIPT
# =============================================================================
# This script sources the environment variables and runs Ansible playbooks
# Usage: ./scripts/run-ansible.sh [playbook_name]

# Source environment variables
source secrets/.env

# Change to src directory
cd src

# Run the specified playbook or show usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 [playbook_name]"
    echo "Example: $0 playbooks/full.yml"
    exit 1
fi

# Run the playbook
ansible-playbook "$1"
