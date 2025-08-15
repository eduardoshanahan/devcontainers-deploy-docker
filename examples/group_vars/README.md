# Group Variables Examples

This directory contains example configuration files for each environment in your Ansible inventory.

## File Structure

```
examples/group_vars/
├── README.md                           # This file
├── all/
│   └── vault.yml.example              # Encrypted sensitive variables
├── production/
│   └── main.yml.example               # Production environment settings
├── staging/
│   └── main.yml.example               # Staging environment settings
└── development/
    └── main.yml.example               # Development environment settings
```

## Setup Instructions

### 1. Create the Directory Structure

```bash
# From your project root
mkdir -p src/inventory/group_vars/{all,production,staging,development}
```

### 2. Copy and Customize Example Files

```bash
# Copy example files
cp examples/group_vars/all/vault.yml.example src/inventory/group_vars/all/vault.yml
cp examples/group_vars/production/main.yml.example src/inventory/group_vars/production/main.yml
cp examples/group_vars/staging/main.yml.example src/inventory/group_vars/staging/main.yml
cp examples/group_vars/development/main.yml.example src/inventory/group_vars/development/main.yml
```

### 3. Customize Configuration

Edit each file with your specific values:

- **Server IP addresses**
- **SSH key paths**
- **Email addresses**
- **Network configurations**
- **Security settings**

### 4. Encrypt Sensitive Data

```bash
# Encrypt the vault file
cd src
ansible-vault encrypt inventory/group_vars/all/vault.yml
```

## Environment-Specific Differences

### Production Environment
- **Clean slate deployments**: Removes all existing Docker resources
- **Strict security**: Maximum security settings and monitoring
- **Network removal enabled**: Allows complete network reconfiguration
- **Long log retention**: 30 days with 100MB max file size
- **Frequent monitoring**: Health checks every 6 minutes

### Staging Environment
- **Preserve resources**: Keeps existing Docker resources
- **Testing enabled**: Network security tests enabled
- **Moderate monitoring**: Health checks every 5 minutes
- **Medium log retention**: 7 days with 50MB max file size
- **Balanced security**: Good security with testing capabilities

### Development Environment
- **Preserve resources**: Keeps existing Docker resources
- **Relaxed monitoring**: Health checks every 10 minutes
- **Short log retention**: 3 days with 25MB max file size
- **Development-friendly**: More lenient security for development work
- **No network tests**: Disabled to avoid interference

## Common Customizations

### Docker Networks
```yaml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
  - name: "cache-network"
    subnet: "172.24.0.0/16"
    driver: "bridge"
```

### Firewall Rules
```yaml
configure_firewall_container_ports:
  - 8080  # Web application
  - 3000  # Node.js application
  - 9000  # Portainer
```

### Monitoring Thresholds
```yaml
configure_monitoring_alert_email: "admin@yourcompany.com"
configure_monitoring_alert_webhook: "https://hooks.slack.com/..."
```

## Security Considerations

1. **Never commit plaintext secrets**: Always use Ansible Vault
2. **Environment separation**: Keep production, staging, and development separate
3. **Access control**: Limit access to production configurations
4. **Regular updates**: Keep configurations updated with security patches
5. **Audit trails**: Document all configuration changes

## Troubleshooting

### Common Issues

1. **Variable not defined**: Check if variable is defined in the correct environment file
2. **Vault decryption failed**: Ensure vault password is correct
3. **Permission denied**: Check file permissions and SSH key access
4. **Network conflicts**: Verify Docker network subnets don't overlap

### Debug Commands

```bash
# Check variable definitions
ansible-inventory --list -y

# Check specific host variables
ansible-inventory --host production_server -y

# Validate playbook syntax
ansible-playbook --syntax-check playbooks/full.yml

# Dry run deployment
ansible-playbook --check playbooks/full.yml
```

## Best Practices

1. **Version control**: Commit all configuration files (except encrypted vault)
2. **Documentation**: Document any customizations or environment-specific settings
3. **Testing**: Test configurations in development/staging before production
4. **Backup**: Keep backups of your configuration files
5. **Review**: Regularly review and update configurations
6. **Security**: Follow security best practices for each environment

These examples provide a solid foundation for setting up your multi-environment Ansible deployment system.
```

## Summary

I've created comprehensive examples for all the group_vars files:

### **1. examples/group_vars/all/vault.yml.example**
- **Purpose**: Encrypted sensitive variables template
- **Content**: Email configuration, passwords, API keys
- **Security**: Shows how to use Ansible Vault for encryption

### **2. examples/group_vars/production/main.yml.example**
- **Purpose**: Production environment configuration
- **Features**: Clean slate deployments, strict security, frequent monitoring
- **Settings**: 30-day log retention, 6-minute health checks, network removal enabled

### **3. examples/group_vars/staging/main.yml.example**
- **Purpose**: Staging environment configuration
- **Features**: Preserve resources, testing enabled, balanced security
- **Settings**: 7-day log retention, 5-minute health checks, network tests enabled

### **4. examples/group_vars/development/main.yml.example**
- **Purpose**: Development environment configuration
- **Features**: Preserve resources, relaxed monitoring, development-friendly
- **Settings**: 3-day log retention, 10-minute health checks, no network tests

### **5. examples/group_vars/README.md**
- **Purpose**: Comprehensive setup guide
- **Content**: Setup instructions, environment differences, customizations
- **Includes**: Security considerations, troubleshooting, best practices

### **Key Features of the Examples:**

1. **Environment-Specific Settings**: Each environment has appropriate configurations
2. **Security Best Practices**: Proper separation of sensitive and non-sensitive data
3. **Comprehensive Documentation**: Clear explanations and setup instructions
4. **Real-World Examples**: Practical configurations users can adapt
5. **Security Considerations**: Guidelines for secure configuration management

### **Benefits:**

1. **Clear Setup Path**: Users can follow step-by-step instructions
2. **Environment Understanding**: Shows differences between production, staging, and development
3. **Security Awareness**: Emphasizes proper handling of sensitive data
4. **Customization Guide**: Provides examples for common customizations
5. **Best Practices**: Includes security and operational best practices

Users can now copy these example files, customize them for their environments, and have a working configuration that follows the project's architecture and security principles.
