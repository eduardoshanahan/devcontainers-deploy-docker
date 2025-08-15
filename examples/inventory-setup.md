# Inventory Setup Examples

This guide shows how to set up the inventory structure for different environments using the current project architecture.

## Current Inventory Structure

```
src/inventory/
├── hosts.yml                    # Server definitions
├── known_hosts                  # SSH host key verification
└── group_vars/
    ├── all/
    │   └── vault.yml           # Encrypted sensitive variables
    ├── production/
    │   └── main.yml            # Production environment settings
    ├── staging/
    │   └── main.yml            # Staging environment settings
    └── development/
        └── main.yml            # Development environment settings
```

## Environment-Specific Configuration

### 1. Production Environment

**File**: `src/inventory/group_vars/production/main.yml`

```yaml
# Server Configuration
vps_server_ip: "your-production-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-production-key"

# Container Deployment User
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-production-deployment-key"

# Docker Network Configuration
configure_docker_networks_default_networks:
  - name: "prod-web-network"
    subnet: "172.20.0.0/16"
    driver: "bridge"
    description: "Production web applications network"
  - name: "prod-db-network"
    subnet: "172.21.0.0/16"
    driver: "bridge"
    description: "Production database network"
  - name: "prod-monitoring-network"
    subnet: "172.22.0.0/16"
    driver: "bridge"
    description: "Production monitoring network"

# Docker Deployment Configuration
deploy_docker_clean_slate: true
configure_docker_networks_remove_all: true

# Firewall Configuration
configure_firewall_docker_networks:
  - "172.20.0.0/16"
  - "172.21.0.0/16"
  - "172.22.0.0/16"

# Feature Flags
features:
  containers:
    networks:
      test_mode: false
```

### 2. Staging Environment

**File**: `src/inventory/group_vars/staging/main.yml`

```yaml
# Server Configuration
vps_server_ip: "your-staging-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-staging-key"

# Container Deployment User
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-staging-deployment-key"

# Docker Network Configuration
configure_docker_networks_default_networks:
  - name: "staging-web-network"
    subnet: "172.20.0.0/16"
    driver: "bridge"
    description: "Staging web applications network"
  - name: "staging-db-network"
    subnet: "172.21.0.0/16"
    driver: "bridge"
    description: "Staging database network"
  - name: "staging-monitoring-network"
    subnet: "172.22.0.0/16"
    driver: "bridge"
    description: "Staging monitoring network"

# Docker Deployment Configuration
deploy_docker_clean_slate: false
configure_docker_networks_remove_all: false

# Firewall Configuration
configure_firewall_enabled: true
configure_firewall_docker_networks:
  - "172.20.0.0/16"
  - "172.21.0.0/16"
  - "172.22.0.0/16"

# Feature Flags
features:
  containers:
    networks:
      test_mode: true
```

### 3. Development Environment

**File**: `src/inventory/group_vars/development/main.yml`

```yaml
# Server Configuration
vps_server_ip: "your-development-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-development-key"

# Container Deployment User
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-development-deployment-key"

# Docker Network Configuration
configure_docker_networks_default_networks:
  - name: "dev-web-network"
    subnet: "172.20.0.0/16"
    driver: "bridge"
    description: "Development web applications network"
  - name: "dev-db-network"
    subnet: "172.21.0.0/16"
    driver: "bridge"
    description: "Development database network"
  - name: "dev-monitoring-network"
    subnet: "172.22.0.0/16"
    driver: "bridge"
    description: "Development monitoring network"

# Docker Deployment Configuration
deploy_docker_clean_slate: false
configure_docker_networks_remove_all: false

# Firewall Configuration
configure_firewall_enabled: true
configure_firewall_docker_networks:
  - "172.20.0.0/16"
  - "172.21.0.0/16"
  - "172.22.0.0/16"

# Feature Flags
features:
  containers:
    networks:
      test_mode: false
```

## Sensitive Data Configuration

### Vault File Setup

**File**: `src/inventory/group_vars/all/vault.yml`

```yaml
# Email Configuration (encrypted with Ansible Vault)
configure_reporting_gmail_user: "your-email@gmail.com"
configure_reporting_gmail_password: "your-app-password"
configure_reporting_email: "admin@yourcompany.com"

# Security Configuration
configure_reporting_gmail_enabled: true
```

**Encrypt the vault file:**
```bash
cd src
ansible-vault encrypt inventory/group_vars/all/vault.yml
```

## Hosts Configuration

**File**: `src/inventory/hosts.yml`

```yaml
all:
  children:
    production:
      hosts:
        production_server:
          ansible_host: "{{ hostvars['localhost']['vps_server_ip'] }}"
          ansible_user: "{{ hostvars['localhost']['initial_deployment_user'] }}"
          ansible_ssh_private_key_file: "{{ hostvars['localhost']['initial_deployment_ssh_key'] }}"
          ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
          ansible_python_interpreter: "/usr/bin/python3.10"
    
    staging:
      hosts:
        staging_server:
          ansible_host: "{{ hostvars['localhost']['vps_server_ip'] }}"
          ansible_user: "{{ hostvars['localhost']['initial_deployment_user'] }}"
          ansible_ssh_private_key_file: "{{ hostvars['localhost']['initial_deployment_ssh_key'] }}"
          ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
          ansible_python_interpreter: "/usr/bin/python3.10"
    
    development:
      hosts:
        development_server:
          ansible_host: "{{ hostvars['localhost']['vps_server_ip'] }}"
          ansible_user: "{{ hostvars['localhost']['initial_deployment_user'] }}"
          ansible_ssh_private_key_file: "{{ hostvars['localhost']['initial_deployment_ssh_key'] }}"
          ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
          ansible_python_interpreter: "/usr/bin/python3.10"
```

## Deployment Commands

### Environment-Specific Deployments

```bash
# Production deployment
ansible-playbook -i inventory/hosts.yml --limit production playbooks/full.yml

# Staging deployment
ansible-playbook -i inventory/hosts.yml --limit staging playbooks/full.yml

# Development deployment
ansible-playbook -i inventory/hosts.yml --limit development playbooks/full.yml
```

### Role-Specific Deployments

```bash
# Deploy only Docker networks
ansible-playbook --tags "configure_docker_networks" playbooks/full.yml

# Deploy only firewall configuration
ansible-playbook --tags "configure_firewall" playbooks/full.yml

# Deploy only monitoring
ansible-playbook --tags "configure_monitoring" playbooks/full.yml
```

## Best Practices

1. **Environment Separation**: Keep production, staging, and development configurations separate
2. **Sensitive Data**: Always encrypt sensitive information using Ansible Vault
3. **Version Control**: Commit encrypted vault files, never commit plaintext secrets
4. **Testing**: Test configurations in development/staging before production
5. **Backup**: Keep backups of your inventory configuration
6. **Documentation**: Document any customizations or environment-specific settings

## Troubleshooting

### Common Issues

1. **Variable not defined**: Check if the variable is defined in the correct environment file
2. **Host key verification failed**: Ensure `known_hosts` contains the correct server keys
3. **Permission denied**: Verify SSH key permissions and user access
4. **Network configuration failed**: Check if Docker networks are properly configured

### Debug Commands

```bash
# Check inventory structure
ansible-inventory --list -y

# Check specific host variables
ansible-inventory --host production_server -y

# Validate playbook syntax
ansible-playbook --syntax-check playbooks/full.yml

# Dry run deployment
ansible-playbook --check playbooks/full.yml
```
```

## Summary of Updates

I've updated the examples to use the current inventory structure:

### **1. examples/DEPLOYMENT_GUIDE.md - Updated:**
- **Fixed playbook references**: Changed from broken individual playbooks to working tag-based commands
- **Updated commands**: Now uses `--tags "configure_docker_networks"` and `--tags "configure_firewall"`

### **2. examples/inventory-setup.md - Created:**
- **Current structure**: Shows the actual environment-based inventory structure
- **Environment examples**: Provides complete examples for production, staging, and development
- **Vault configuration**: Shows how to set up encrypted sensitive data
- **Hosts configuration**: Demonstrates the current `hosts.yml` structure
- **Deployment commands**: Shows environment-specific and role-specific deployment approaches
- **Best practices**: Includes current project best practices and troubleshooting

### **Key Features of the Updated Examples:**

1. **Environment-Based Structure**: Examples now reflect the actual `production/`, `staging/`, `development/` organization
2. **Working Commands**: All examples use the current working playbook structure with tags
3. **Current File Paths**: References point to the actual existing inventory structure
4. **Vault Integration**: Shows how to properly handle sensitive data with Ansible Vault
5. **Practical Examples**: Provides real-world configuration examples that users can adapt

### **Benefits:**

1. **Accurate Documentation**: Examples now match the actual working project structure
2. **Working Commands**: Users can copy and paste examples that will actually work
3. **Clear Structure**: Shows how to properly organize environment-specific configurations
4. **Security Best Practices**: Demonstrates proper handling of sensitive data
5. **Environment Management**: Shows how to manage multiple environments effectively

The examples now provide a complete, accurate guide for users to set up and use the current inventory structure.
