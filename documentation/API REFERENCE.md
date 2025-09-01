# API Reference

This document provides comprehensive API documentation for the Docker Installation and Server Configuration project using Ansible.

## Table of Contents

- [Playbooks](#playbooks)
- [Roles](#roles)
- [Variables](#variables)
- [Configuration Files](#configuration-files)
- [Network Security](#network-security)
- [Security Features](#security-features)

## Playbooks

### Core Playbooks

#### `full.yml`

Complete system deployment playbook that runs all roles in the recommended order.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles Executed:**

1. `update_ubuntu` - System updates and security patches
2. `disable_password_authentication` - SSH security hardening
3. `create_deployment_user` - Create dedicated deployment user
4. `configure_firewall` - UFW firewall configuration
5. `configure_fail2ban` - SSH brute force protection
6. `configure_monitoring` - System monitoring setup
7. `configure_log_rotation` - Automated log management
8. `configure_security_updates` - Automatic security updates
9. `deploy_docker` - Docker installation and configuration
10. `configure_docker_networks` - Secure Docker networks
11. `configure_container_security` - Container security hardening
12. `test_network_security` - Network security validation

**Post-deployment:** Sends completion notification email if configured.

#### `update_ubuntu.yml`

Updates Ubuntu system packages and applies security patches.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `update_ubuntu`

#### `deploy_docker.yml`

Installs and configures Docker on the target server.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `deploy_docker`

### Security Playbooks

#### `configure_security_updates.yml`

Configures automatic security updates with email notifications.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_security_updates`

#### `create_deployment_user.yml`

Creates a dedicated deployment user with SSH key authentication.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `create_deployment_user`

#### `disable_password_authentication.yml`

Disables password authentication for SSH, enforcing key-based authentication.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `disable_password_authentication`

#### `configure_firewall.yml`

Configures UFW firewall with secure Docker network rules.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:**

1. `configure_docker_networks` - Create networks first
2. `configure_firewall` - Configure firewall rules

#### `configure_fail2ban.yml`

Installs and configures Fail2ban for SSH brute force protection.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_fail2ban`

### Network and Monitoring Playbooks

#### `configure_docker_networks.yml`

Creates secure Docker networks with specific IP ranges.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_docker_networks`

#### `configure_monitoring.yml`

Sets up system monitoring and health checks.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_monitoring`

#### `configure_log_rotation.yml`

Configures automated log rotation and management.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_log_rotation`

#### `test_network_security.yml`

Tests network security configurations and validates firewall rules.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `test_network_security`

### Utility Playbooks

#### `reboot_server.yml`

Safely reboots the server after configuration changes.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

#### `configure_container_security.yml`

Applies additional container security hardening.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_container_security`

#### `configure_remote_logging.yml`

Configures remote logging capabilities.

**Hosts:** `all`  
**Become:** `true`  
**Remote User:** `{{ initial_deployment_user }}`

**Roles:** `configure_remote_logging`

## Roles

### Core Roles

#### `update_ubuntu`

Updates Ubuntu system packages and applies security patches.

**Tasks:**

- Update package lists
- Upgrade all packages
- Install security updates
- Clean package cache

#### `deploy_docker`

Installs and configures Docker with secure defaults.

**Tasks:**

- Install Docker packages
- Configure Docker daemon
- Create Docker networks
- Set up network policies
- Configure container security

**Variables:**

- `deploy_docker_security_enabled`: Enable additional security features
- `deploy_docker_packages`: List of Docker packages to install
- `deploy_docker_network_configuration`: Network configuration object
- `deploy_docker_network_policies`: Network policies object

#### `create_deployment_user`

Creates a dedicated deployment user with SSH key authentication.

**Tasks:**

- Create deployment user
- Set up SSH key authentication
- Configure sudo access
- Set proper permissions

**Variables:**

- `containers_deployment_user`: Username for deployment user
- `containers_deployment_user_ssh_key`: SSH private key path
- `containers_deployment_user_ssh_key_public`: SSH public key path

### Security Roles

#### `configure_security_updates`

Configures automatic security updates with notifications.

**Tasks:**

- Install unattended-upgrades
- Configure update settings
- Set up email notifications
- Configure Slack/Discord webhooks

**Variables:**

- `configure_security_updates_email`: Email for notifications
- `configure_security_updates_gmail_enabled`: Enable Gmail notifications
- `configure_security_updates_gmail_user`: Gmail username
- `configure_security_updates_gmail_password`: Gmail app password
- `configure_security_updates_gmail_smtp_server`: SMTP server
- `configure_security_updates_gmail_smtp_port`: SMTP port
- `configure_security_updates_slack_webhook`: Slack webhook URL
- `configure_security_updates_discord_webhook`: Discord webhook URL

#### `disable_password_authentication`

Disables SSH password authentication.

**Tasks:**

- Configure SSH to disable password auth
- Enable key-based authentication
- Restart SSH service

#### `configure_firewall`

Configures UFW firewall with secure Docker network rules.

**Tasks:**

- Install and enable UFW
- Configure default policies
- Allow SSH access
- Configure Docker network rules
- Set logging level

**Variables:**

- `configure_firewall_docker_networks`: List of Docker network ranges
- `configure_firewall_container_ports`: List of container ports to allow
- `configure_firewall_logging_level`: UFW logging level

#### `configure_fail2ban`

Installs and configures Fail2ban for SSH protection.

**Tasks:**

- Install Fail2ban
- Configure SSH jail
- Set up email notifications
- Start and enable service

### Network Roles

#### `configure_docker_networks`

Creates secure Docker networks with specific IP ranges.

**Tasks:**

- Create default networks
- Configure network isolation
- Set up custom networks
- Apply network policies

**Variables:**

- `configure_docker_networks_default_networks`: Default network configuration
- `configure_docker_networks_custom_networks`: Custom network configuration

#### `test_network_security`

Tests network security configurations.

**Tasks:**

- Validate firewall rules
- Test network connectivity
- Verify Docker network isolation
- Generate security report

### Monitoring Roles

#### `configure_monitoring`

Sets up system monitoring and health checks.

**Tasks:**

- Install monitoring tools
- Configure health checks
- Set up alerting
- Configure log monitoring

**Variables:**

- `configure_monitoring_enabled`: Enable monitoring
- `configure_monitoring_alert_email`: Alert email address
- `configure_monitoring_alert_webhook`: Alert webhook URL

#### `configure_log_rotation`

Configures automated log rotation.

**Tasks:**

- Configure logrotate
- Set up log retention policies
- Configure log compression
- Set up log monitoring

#### `configure_remote_logging`

Configures remote logging capabilities.

**Tasks:**

- Set up remote logging
- Configure log forwarding
- Configure log aggregation

#### `configure_container_security`

Applies container security hardening.

**Tasks:**

- Configure AppArmor profiles
- Set up seccomp policies
- Configure resource limits
- Apply security policies

## Variables

### Server Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `vps_server_ip` | string | - | Server IP or hostname |
| `initial_deployment_user` | string | `ubuntu` | Initial deployment user |
| `initial_deployment_ssh_key` | string | `~/.ssh/your-ssh-key` | SSH private key path |
| `containers_deployment_user` | string | `docker_deployment` | Deployment user username |
| `containers_deployment_user_ssh_key` | string | `~/.ssh/your-deployment-key` | Deployment user SSH key |
| `containers_deployment_user_ssh_key_public` | string | `/path/to/your/public/key.pub` | Deployment user public key |

### SSH Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `ansible_ssh_common_args` | string | `-o IdentitiesOnly=yes -o PreferredAuthentications=publickey` | SSH connection arguments |
| `ansible_python_interpreter` | string | `/usr/bin/python3.10` | Python interpreter path |

### Security Updates Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `configure_security_updates_email` | string | - | Email for security notifications |
| `configure_security_updates_gmail_enabled` | boolean | `false` | Enable Gmail notifications |
| `configure_security_updates_gmail_user` | string | - | Gmail username |
| `configure_security_updates_gmail_password` | string | - | Gmail app password |
| `configure_security_updates_gmail_smtp_server` | string | `smtp.gmail.com` | Gmail SMTP server |
| `configure_security_updates_gmail_smtp_port` | string | `465` | Gmail SMTP port |
| `configure_security_updates_slack_webhook` | string | - | Slack webhook URL |
| `configure_security_updates_discord_webhook` | string | - | Discord webhook URL |

### Firewall Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `configure_firewall_docker_networks` | list | `[172.20.0.0/16, 172.21.0.0/16, 172.22.0.0/16]` | Docker network ranges |
| `configure_firewall_container_ports` | list | `[8080, 3000, 9000, 5432, 3306]` | Container ports to allow |
| `configure_firewall_logging_level` | string | `medium` | UFW logging level |

### Docker Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `deploy_docker_network_configuration` | object | - | Docker network configuration |
| `deploy_docker_network_policies` | object | - | Network policies |
| `deploy_docker_security_enabled` | boolean | `false` | Enable Docker security features |
| `deploy_docker_packages` | list | `[docker-ce, docker-ce-cli, containerd.io]` | Docker packages to install |

### Docker Networks Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `configure_docker_networks_default_networks` | list | - | Default network configuration |
| `configure_docker_networks_custom_networks` | list | - | Custom network configuration |

### Monitoring Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `configure_monitoring_enabled` | boolean | `true` | Enable monitoring |
| `configure_monitoring_alert_email` | string | - | Alert email address |
| `configure_monitoring_alert_webhook` | string | - | Alert webhook URL |

## Configuration Files

### Ansible Configuration Files

#### `ansible.cfg` (Default)

Secure production-ready configuration with strict host key checking.

#### Development Overrides

For development environments, use environment variables to override secure defaults:

```bash
# Disable host key checking for development
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml

# Or use environment variables
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no"
ansible-playbook playbooks/full.yml
```

### Inventory Files

#### `inventory/hosts.yml`

Host definitions and group assignments.

#### `inventory/known_hosts`

Managed host key verification file for secure connections.

#### `inventory/group_vars/`

Environment-specific configuration:

- `production/main.yml` - Production settings
- `staging/main.yml` - Staging settings  
- `development/main.yml` - Development settings
- `all/vault.yml` - Encrypted sensitive data

## Network Security

### Default Docker Networks

| Network Name | Subnet | Purpose |
|--------------|--------|---------|
| `web-network` | `172.20.0.0/16` | Web applications and frontend services |
| `db-network` | `172.21.0.0/16` | Databases and backend services |
| `monitoring-network` | `172.22.0.0/16` | Monitoring and logging services |

### Network Policies

#### Web Services

- nginx, apache, nodejs, react, vue

#### Database Services

- postgres, mysql, redis, mongodb

#### Monitoring Services

- prometheus, grafana, elasticsearch, kibana

### Security Features

#### SSH Security

- Key-based authentication only
- Password authentication disabled
- Fail2ban protection
- Host key verification

#### Firewall Security

- UFW with restrictive rules
- Specific Docker network ranges
- Container port access control
- Network activity logging

#### Docker Security

- Network isolation
- Bridge netfilter enabled
- IP forwarding control
- Container security policies

#### Monitoring Security

- System health monitoring
- Log rotation and retention
- Security alert notifications
- Network traffic monitoring

## Usage Examples

### Basic Deployment

```bash
# Full deployment with default configuration
ansible-playbook playbooks/full.yml

# Development deployment with relaxed security
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml

# Production deployment with strict security
ansible-playbook playbooks/full.yml
```

### Individual Components

```bash
# Update system only
ansible-playbook --tags "update_ubuntu" playbooks/full.yml

# Install Docker only
ansible-playbook --tags "deploy_docker" playbooks/full.yml

# Configure firewall only
ansible-playbook --tags "configure_firewall" playbooks/full.yml

# Configure monitoring only
ansible-playbook --tags "configure_monitoring" playbooks/full.yml
```

### Security Configuration

```bash
# Configure security updates
ansible-playbook --tags "configure_security_updates" playbooks/full.yml

# Configure Fail2ban
ansible-playbook --tags "configure_fail2ban" playbooks/full.yml

# Test network security
ansible-playbook --tags "test_network_security" playbooks/full.yml
```

### Network Configuration

```bash
# Configure Docker networks
ansible-playbook --tags "configure_docker_networks" playbooks/full.yml

# Configure container security
ansible-playbook --tags "configure_container_security" playbooks/full.yml
```

## Error Handling

### Common Issues

- SSH connection failures
- Host key verification errors
- Permission denied errors
- Network configuration conflicts
- Docker service failures

### Troubleshooting

- Check SSH key permissions
- Verify host key fingerprints
- Review firewall rules
- Check Docker service status
- Validate network configurations

## Best Practices

### Security

- Always use host key verification in production
- Keep SSH keys secure and rotated
- Monitor firewall logs regularly
- Update security patches promptly
- Use specific network ranges instead of broad access

### Deployment

- Test in development environment first
- Use separate configurations for dev/prod
- Monitor deployment logs
- Validate network security after deployment
- Keep backup configurations

### Maintenance

- Regular security updates
- Monitor system resources
- Review log files
- Test network connectivity
- Update Docker images regularly
