# Ansible Security Configuration

## Overview

This document outlines the security configuration for Ansible deployments. We use a multi-layered approach to ensure secure connections while maintaining flexibility for different environments.

## Configuration Files

- `ansible.cfg` - Main configuration (secure production defaults)
- `ansible.dev.cfg` - Development configuration (less strict for testing)
- `ansible.prod.cfg` - Explicit production configuration (maximum security)
- `inventory/known_hosts` - Managed host key verification file

## Host Key Management

### Initial Setup

1. **Get your server's host key fingerprint:**

   ```bash
   # Method 1: Using ssh-keyscan (recommended)
   ssh-keyscan -H your_server_ip >> inventory/known_hosts
   
   # Method 2: Manual addition
   echo "your_server_ip ssh-rsa AAAAB3NzaC1yc2E..." >> inventory/known_hosts
   ```

2. **Verify the host key:**

   ```bash
   # Test the connection with host key checking
   ansible all -m ping
   ```

### Updating Host Keys

When server SSH keys change (e.g., after server rebuild):

1. **Remove old key:**

   ```bash
   # Remove the old entry from known_hosts
   sed -i '/your_server_ip/d' inventory/known_hosts
   ```

2. **Add new key:**

   ```bash
   # Add the new host key
   ssh-keyscan -H your_server_ip >> inventory/known_hosts
   ```

## Usage by Environment

### Production (Secure)

```bash
# Use default secure configuration
ansible-playbook playbook.yml

# Or explicitly use production config
ansible-playbook -f ansible.prod.cfg playbook.yml
```

### Development (Less Secure)

```bash
# Use development configuration for testing
ansible-playbook -f ansible.dev.cfg playbook.yml
```

## Security Features

### Enabled Security Measures

- [x] Host key checking enabled
- [x] Strict host key verification
- [x] Managed known_hosts file
- [x] SSH key fingerprint verification
- [x] Man-in-the-middle attack prevention

### Development Overrides

- [ ] Host key checking disabled (for testing only)
- [ ] Strict host key checking disabled (for testing only)
- **Warning:** Use only in trusted development environments

## Troubleshooting

### Common Issues

1. **"Host key verification failed"**

   ```bash
   # Add the host key to known_hosts
   ssh-keyscan -H your_server_ip >> inventory/known_hosts
   ```

2. **"WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"**

   ```bash
   # Remove old key and add new one
   sed -i '/your_server_ip/d' inventory/known_hosts
   ssh-keyscan -H your_server_ip >> inventory/known_hosts
   ```

3. **Connection timeouts with strict checking**

   ```bash
   # Temporarily use development config for testing
   ansible-playbook -f ansible.dev.cfg playbook.yml
   ```

### Verification Commands

```bash
# Test connection with security
ansible all -m ping

# Check host key status
ssh -o StrictHostKeyChecking=yes your_server_ip

# Verify known_hosts file
cat inventory/known_hosts
```

## Best Practices

### Security

- Never disable host key checking in production
- Regularly update known_hosts when server keys change
- Use Ansible Vault for sensitive variables
- Consider using SSH certificates for additional security
- Monitor for unauthorized host key changes

### Development

- Use development config only in trusted environments
- Never commit development config to production systems
- Test with production config before deployment
- Document any temporary security bypasses

### Maintenance

- Regularly audit known_hosts file
- Remove unused host entries
- Keep documentation updated
- Review security settings periodically

## Advanced Configuration

### Using Ansible Vault

```bash
# Encrypt sensitive variables
ansible-vault encrypt group_vars/all/vault.yml

# Run playbook with vault
ansible-playbook --ask-vault-pass playbook.yml
```

### SSH Certificate Authentication

```bash
# Generate SSH certificate
ssh-keygen -s ca_key -I user_id -n user -V +52w user_key.pub

# Configure in ansible.cfg
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=inventory/known_hosts -o CertificateFile=~/.ssh/user_key-cert.pub
```

## Emergency Procedures

### Quick Security Disable (Emergency Only)

```bash
# Use development config temporarily
ansible-playbook -f ansible.dev.cfg playbook.yml

# Or override SSH args
ansible-playbook -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" playbook.yml
```

### Restore Security

```bash
# Return to secure configuration
ansible-playbook playbook.yml
```

---

**Security Note:** This configuration prioritizes security over convenience. Always use the most secure configuration possible for your environment.
