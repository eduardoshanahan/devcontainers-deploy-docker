# Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying and configuring Ubuntu VPS servers using this Ansible-based infrastructure automation project. The deployment process is designed to be secure, repeatable, and production-ready.

## Prerequisites

### 1. Development Environment Setup

#### Required Software

- **Docker**: For running the development container
- **VS Code** or **Cursor**: For development environment
- **Git**: For version control
- **SSH Client**: For remote server access

#### System Requirements

- **Operating System**: Linux, macOS, or Windows with WSL2
- **Memory**: Minimum 4GB RAM (8GB recommended)
- **Storage**: At least 10GB free space
- **Network**: Stable internet connection

### 2. Target Server Requirements

#### Server Specifications

- **Operating System**: Ubuntu 22.04 LTS (recommended)
- **CPU**: Minimum 1 vCPU (2+ recommended)
- **Memory**: Minimum 1GB RAM (2GB+ recommended)
- **Storage**: Minimum 20GB disk space
- **Network**: Public IP address with SSH access

#### Server Access

- **SSH Access**: Root or sudo user access required
- **SSH Keys**: Key-based authentication configured
- **Network Access**: Outbound internet access for package installation

## Initial Setup

### 1. Clone and Configure Project

```bash
# Clone the repository
git clone <repository-url>
cd ansible-docker-deployment

# Copy environment configuration
cp .devcontainer/config/.env.example .devcontainer/config/.env

# Edit environment variables
nano .devcontainer/config/.env
```

#### Environment Configuration

```bash
# User configuration
HOST_USERNAME=your_username
HOST_UID=1000
HOST_GID=1000

# Git configuration
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# Editor choice
EDITOR_CHOICE=code  # or 'cursor'

# Docker configuration
DOCKER_IMAGE_NAME=devcontainers-ansible
DOCKER_IMAGE_TAG=latest
```

### 2. Launch Development Environment

```bash
# Make launch script executable
chmod +x launch.sh

# Launch the development environment
./launch.sh
```

The development container will start with:

- Ansible 9.2.0 with linting
- Docker CLI tools
- SSH agent with key management
- VS Code extensions for Ansible, YAML, Docker

### 3. Configure Server Inventory

```bash
# Navigate to Ansible directory
cd src

# Copy and customize the appropriate environment file
cp inventory/group_vars/production/main.yml inventory/group_vars/production/main.yml.backup
nano inventory/group_vars/production/main.yml
```

#### Required Configuration Variables

```yaml
# src/inventory/group_vars/production/main.yml
# Server Configuration
vps_server_ip: "your-production-server-ip-or-hostname"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-production-ssh-key"

# Container Deployment User
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-production-deployment-key"
containers_deployment_user_ssh_key_public: "/path/to/your/public/key.pub"

# SSH Configuration
ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
ansible_python_interpreter: "/usr/bin/python3.10"

# Security Updates Configuration
configure_security_updates_email: "your-email@gmail.com"
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-gmail@gmail.com"
configure_security_updates_gmail_password: "your-app-password"
configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
configure_security_updates_gmail_smtp_port: "465"
```

### 4. Configure Host Key Verification

```bash
# Add your server's host key to known_hosts
ssh-keyscan -H your_server_ip >> inventory/known_hosts

# Verify the host key
ssh -o StrictHostKeyChecking=yes your_server_ip
```

## Deployment Process

### 1. Full System Deployment

#### Complete Deployment (Recommended for New Servers)

```bash
# Navigate to Ansible directory
cd src

# Run complete deployment
ansible-playbook playbooks/full.yml
```

This playbook executes the following roles in order:

1. **update_ubuntu**: System updates and security patches
2. **disable_password_authentication**: SSH security hardening
3. **create_deployment_user**: Dedicated deployment user creation
4. **configure_firewall**: UFW firewall configuration
5. **configure_fail2ban**: SSH brute force protection
6. **configure_monitoring**: System monitoring setup
7. **configure_log_rotation**: Automated log management
8. **configure_security_updates**: Automatic security updates
9. **deploy_docker**: Docker installation and configuration
10. **configure_docker_networks**: Secure network segmentation
11. **configure_container_security**: Container security hardening
12. **test_network_security**: Security validation testing

#### Deployment Verification

```bash
# Check deployment status
ansible all -m ping

# Verify Docker installation
ansible all -m shell -a "docker --version"

# Check firewall status
ansible all -m shell -a "sudo ufw status"

# Verify network configuration
ansible all -m shell -a "docker network ls"
```

### 2. Individual Component Deployment

#### System Updates

```bash
# Update Ubuntu system
ansible-playbook --tags "update_ubuntu" playbooks/full.yml
```

#### Docker Installation

```bash
# Install and configure Docker
ansible-playbook --tags "deploy_docker" playbooks/full.yml
```

#### Security Configuration

```bash
# Configure firewall
ansible-playbook --tags "configure_firewall" playbooks/full.yml

# Configure fail2ban
ansible-playbook --tags "configure_fail2ban" playbooks/full.yml

# Configure security updates
ansible-playbook --tags "configure_security_updates" playbooks/full.yml
```

#### Network Configuration

```bash
# Configure Docker networks
ansible-playbook --tags "configure_docker_networks" playbooks/full.yml

# Test network security
ansible-playbook --tags "test_network_security" playbooks/full.yml
```

#### Monitoring Setup

```bash
# Configure monitoring
ansible-playbook --tags "configure_monitoring" playbooks/full.yml

# Configure log rotation
ansible-playbook --tags "configure_log_rotation" playbooks/full.yml
```

### 3. Environment-Specific Deployments

#### Development Environment

```bash
# Use development overrides (relaxed security)
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml
```

#### Production Environment

```bash
# Use default configuration (strict security)
ansible-playbook playbooks/full.yml
```

## Post-Deployment Configuration

### 1. Verify Deployment

#### System Health Check

```bash
# Check system status
ansible all -m shell -a "systemctl status"

# Check Docker status
ansible all -m shell -a "sudo systemctl status docker"

# Check firewall status
ansible all -m shell -a "sudo ufw status verbose"

# Check fail2ban status
ansible all -m shell -a "sudo systemctl status fail2ban"
```

#### Security Verification

```bash
# Test SSH security
ansible all -m shell -a "sudo sshd -T | grep -E 'password|permitroot'"

# Check Docker networks
ansible all -m shell -a "docker network ls"

# Verify network isolation
ansible all -m shell -a "sudo ufw status numbered"
```

### 2. Application Deployment

#### Deploy Sample Application

```bash
# Copy application files to server
scp -r ./your-app/ user@server:/opt/apps/

# SSH to server and deploy
ssh user@server
cd /opt/apps/your-app
docker-compose up -d
```

#### Verify Application Deployment

```bash
# Check container status
docker ps

# Test application connectivity
curl http://localhost:8080

# Check application logs
docker logs container-name
```

### 3. Monitoring Setup

#### Configure Monitoring Alerts

```bash
# Set up email notifications
ansible-playbook --tags "configure_security_updates" playbooks/full.yml

# Configure monitoring thresholds
# Edit monitoring configuration as needed
```

#### Verify Monitoring

```bash
# Check monitoring services
ansible all -m shell -a "sudo systemctl status monitoring"

# Test alert system
ansible all -m shell -a "sudo /opt/security-updates/security-update-notify.sh 'Test Alert' 'This is a test notification'"
```

## Troubleshooting

### 1. Common Issues

#### SSH Connection Issues

```bash
# Check SSH connectivity
ssh -v user@server

# Verify host key
ssh -o StrictHostKeyChecking=yes user@server

# Check SSH configuration
sudo sshd -T | grep -E 'password|permitroot'
```

#### Ansible Connection Issues

```bash
# Test Ansible connectivity
ansible all -m ping

# Check inventory configuration
ansible-inventory --list

# Verify SSH keys
ssh-add -l
```

#### Docker Issues

```bash
# Check Docker service
sudo systemctl status docker

# Check Docker networks
docker network ls

# Check Docker daemon logs
sudo journalctl -u docker
```

#### Firewall Issues

```bash
# Check firewall status
sudo ufw status verbose

# Check firewall rules
sudo ufw status numbered

# Check firewall logs
sudo tail -f /var/log/ufw.log
```

### 2. Debug Procedures

#### Enable Verbose Logging

```bash
# Run playbook with verbose output
ansible-playbook -vvv playbooks/full.yml

# Check Ansible logs
tail -f /var/log/ansible.log
```

#### Manual Verification

```bash
# SSH to server and check manually
ssh user@server

# Check system status
sudo systemctl status

# Check Docker status
sudo systemctl status docker

# Check network configuration
ip addr show
```

### 3. Recovery Procedures

#### Rollback Deployment

```bash
# Revert to previous configuration
ansible-playbook --check playbooks/full.yml

# Manual rollback if needed
ssh user@server
sudo systemctl stop docker
sudo ufw reset
```

#### Emergency Access

```bash
# If SSH access is lost, use console access
# Reset SSH configuration if needed
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh
```

## Maintenance Procedures

### 1. Regular Maintenance

#### System Updates Maintenance

```bash
# Run system updates
ansible-playbook --tags "update_ubuntu" playbooks/full.yml

# Check for required reboots
ansible-playbook --tags "reboot_server" playbooks/full.yml
```

#### Security Updates

```bash
# Configure automatic security updates
ansible-playbook --tags "configure_security_updates" playbooks/full.yml

# Check security update status
sudo unattended-upgrade --dry-run
```

#### Log Management

```bash
# Configure log rotation
ansible-playbook --tags "configure_log_rotation" playbooks/full.yml

# Check log status
sudo logrotate -d /etc/logrotate.conf
```

### 2. Backup Procedures

#### Configuration Backup

```bash
# Backup Ansible configuration
tar -czf ansible-config-backup-$(date +%Y%m%d).tar.gz src/

# Backup server configuration
ansible all -m shell -a "sudo tar -czf /tmp/server-config-backup-$(date +%Y%m%d).tar.gz /etc/"
```

#### Data Backup

```bash
# Backup Docker volumes
docker run --rm -v volume_name:/data -v $(pwd):/backup alpine tar czf /backup/volume-backup.tar.gz -C /data .

# Backup application data
scp -r user@server:/opt/apps/ ./backup/
```

### 3. Monitoring and Alerting

#### Health Checks

```bash
# Run health check playbook
ansible-playbook --tags "test_network_security" playbooks/full.yml

# Check system resources
ansible all -m shell -a "df -h && free -h && uptime"
```

#### Alert Configuration

```bash
# Configure email alerts
ansible-playbook --tags "configure_security_updates" playbooks/full.yml

# Test alert system
ansible all -m shell -a "sudo /opt/security-updates/security-update-notify.sh 'Test' 'Alert Test'"
```

## Advanced Configuration

### 1. Custom Network Configuration

#### Modify Network Ranges

```yaml
# Edit inventory/group_vars/production/main.yml
configure_docker_networks_default_networks:
  - name: "web-network"
    subnet: "172.20.0.0/16"
  - name: "db-network"
    subnet: "172.21.0.0/16"
  - name: "monitoring-network"
    subnet: "172.22.0.0/16"
```

#### Add Custom Networks

```yaml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
  - name: "cache-network"
    subnet: "172.24.0.0/16"
```

### 2. Custom Firewall Rules

#### Add Application Ports

```yaml
configure_firewall_container_ports:
  - 8080  # Web application
  - 3000  # Node.js application
  - 9000  # Portainer
  - 5432  # PostgreSQL
  - 3306  # MySQL
```

#### Custom Firewall Rules

```bash
# Add custom UFW rules
sudo ufw allow from 192.168.1.0/24 to any port 22
sudo ufw allow from 10.0.0.0/8 to any port 80
```

### 3. Monitoring Configuration

#### Custom Monitoring

```yaml
configure_monitoring_enabled: true
configure_monitoring_alert_email: "admin@example.com"
configure_monitoring_alert_webhook: "https://hooks.slack.com/..."
```

#### Log Configuration

```yaml
configure_log_rotation_enabled: true
configure_log_rotation_max_size: "100M"
configure_log_rotation_keep_days: 30
```

## Best Practices

### 1. Security Best Practices

- Always use host key verification in production
- Regularly rotate SSH keys
- Monitor security logs and alerts
- Keep systems updated with security patches
- Use strong passwords and key-based authentication

### 2. Deployment Best Practices

- Test deployments in development environment first
- Use version control for all configurations
- Document all customizations and changes
- Maintain backup and recovery procedures
- Monitor deployment success and failures

### 3. Maintenance Best Practices

- Schedule regular maintenance windows
- Test backup and recovery procedures
- Monitor system performance and resources
- Keep documentation updated
- Review and update security configurations

This deployment guide provides comprehensive instructions for deploying and maintaining secure, containerized applications on Ubuntu VPS servers using this Ansible-based infrastructure automation project.
