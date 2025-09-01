# Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying and configuring Ubuntu VPS servers using this Ansible-based infrastructure automation project. The deployment process is designed to be secure, repeatable, and production-ready with comprehensive monitoring and reporting capabilities.

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

### 3. Configure Server Secrets

#### Set Up Ansible Vault

```bash
# Navigate to secrets directory
cd secrets

# Copy the example vault file
cp vault.example.yml vault.yml

# Edit the vault file with your server details
nano vault.yml
```

#### Required Vault Configuration

```yaml
# secrets/vault.yml
# Server Configuration
vault_vps_server_ip: "your-vps-server-ip-or-hostname.com"
vault_initial_deployment_user: "ubuntu"
vault_initial_deployment_ssh_key: "~/.ssh/your-initial-deployment-key"

# Container deployment user (created during deployment)
vault_containers_deployment_user: "docker_deployment"
vault_containers_deployment_user_ssh_key: "~/.ssh/your-container-deployment-key"
vault_containers_deployment_user_ssh_key_public: "/path/to/your/public/key.pub"

# Email Configuration
vault_configure_security_updates_email: "admin@yourdomain.com"
vault_configure_security_updates_gmail_user: "your-email@gmail.com"
vault_configure_security_updates_gmail_password: "your-gmail-app-password"

# Monitoring and reporting email configuration
vault_configure_monitoring_alert_email: "alerts@yourdomain.com"
vault_configure_reporting_email: "reports@yourdomain.com"
vault_configure_reporting_gmail_user: "your-email@gmail.com"
vault_configure_reporting_gmail_password: "your-gmail-app-password"

# Container security alerts
vault_configure_container_security_alert_email: "security@yourdomain.com"

# SMTP Configuration
vault_configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
vault_configure_security_updates_gmail_smtp_port: "465"
vault_configure_reporting_gmail_smtp_server: "smtp.gmail.com"
vault_configure_reporting_gmail_smtp_port: "465"

# Remote logging (optional)
vault_configure_remote_logging_server: "your-remote-logging-server.com"
```

#### Encrypt the Vault File

```bash
# Encrypt the vault file
ansible-vault encrypt vault.yml

# Set up vault password file
echo "your-vault-password" > .vault_pass
chmod 600 .vault_pass
```

#### Configure Environment Variables

```bash
# Edit the .env file
nano .env
```

```bash
# secrets/.env
# Ansible Configuration
ANSIBLE_VAULT_PASSWORD_FILE=secrets/.vault_pass
ANSIBLE_VAULT_FILE=secrets/vault.yml
ANSIBLE_CONFIG=src/ansible.cfg

# Development overrides (optional)
ANSIBLE_HOST_KEY_CHECKING=False
ANSIBLE_VERBOSITY=1
```

### 4. Configure Host Key Verification

```bash
# Add your server's host key to known_hosts
ssh-keyscan -H your_server_ip >> src/inventory/known_hosts

# Verify the host key
ssh -o StrictHostKeyChecking=yes your_server_ip
```

## Deployment Process

### 1. Automated Deployment (Recommended)

#### Using the Deployment Script

```bash
# Navigate to workspace root
cd /workspace

# Run the automated deployment script
./scripts/deploy-full.sh
```

This script will:

1. **Validate Environment**: Check all prerequisites and configuration
2. **Load Variables**: Source environment variables and vault configuration
3. **Preflight Checks**: Validate server connectivity and configuration
4. **Deploy System**: Execute the complete deployment playbook
5. **Send Notifications**: Email deployment completion status

#### Manual Deployment

```bash
# Navigate to Ansible directory
cd src

# Run complete deployment
ansible-playbook playbooks/full.yml
```

### 2. Full System Deployment

The main playbook (`playbooks/full.yml`) executes the following roles in order:

1. **update_ubuntu**: System updates and security patches
2. **disable_password_authentication**: SSH security hardening
3. **create_deployment_user**: Dedicated deployment user creation
4. **deploy_docker**: Docker installation and configuration
5. **configure_firewall**: UFW firewall configuration
6. **configure_security_updates**: Automatic security updates
7. **configure_monitoring**: System monitoring setup
8. **configure_reporting**: Automated reporting system
9. **configure_container_security**: Container security hardening
10. **configure_remote_logging**: Centralized logging configuration
11. **configure_log_download**: Secure log collection
12. **configure_log_rotation**: Automated log management
13. **configure_fail2ban**: Intrusion prevention setup
14. **test_network_security**: Security validation testing

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

# Check monitoring status
ansible all -m shell -a "sudo systemctl status prometheus-node-exporter"
```

### 3. Individual Component Deployment

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

# Configure reporting
ansible-playbook --tags "configure_reporting" playbooks/full.yml

# Configure log rotation
ansible-playbook --tags "configure_log_rotation" playbooks/full.yml
```

#### Container Security

```bash
# Configure container security scanning
ansible-playbook --tags "configure_container_security" playbooks/full.yml
```

### 4. Development Environment Overrides

For development and testing, you can use environment variables to override secure defaults:

```bash
# Disable host key checking for development
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml

# Enable verbose output
ANSIBLE_VERBOSITY=2 ansible-playbook playbooks/full.yml

# Use development-specific variables
ANSIBLE_EXTRA_VARS="configure_docker_networks_test_mode=true" ansible-playbook playbooks/full.yml
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

# Check monitoring status
ansible all -m shell -a "sudo systemctl status prometheus-node-exporter"
```

#### Security Verification

```bash
# Test SSH security
ansible all -m shell -a "sudo sshd -T | grep -E 'password|permitroot'"

# Check Docker networks
ansible all -m shell -a "docker network ls"

# Verify network isolation
ansible all -m shell -a "sudo ufw status numbered"

# Check container security scanning
ansible all -m shell -a "sudo trivy --version"
```

#### Reporting System Verification

```bash
# Check reporting system status
ansible all -m shell -a "sudo systemctl status cron"

# Verify report generation
ansible all -m shell -a "sudo /opt/reports/generate-daily-report.sh"

# Check email configuration
ansible all -m shell -a "sudo /opt/reports/email-report.sh test"
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

#### Use Secure Docker Compose Template

```bash
# Copy the secure template
cp examples/docker-compose.secure.yml your-app/docker-compose.yml

# Customize for your application
nano your-app/docker-compose.yml

# Deploy with network segmentation
docker-compose up -d
```

#### Verify Application Deployment

```bash
# Check container status
docker ps

# Verify network connectivity
docker network inspect web-network
docker network inspect db-network
docker network inspect monitoring-network

# Test application functionality
curl http://your-app-domain.com
```

### 3. Monitoring and Reporting

#### Access System Reports

```bash
# Generate manual reports
sudo /opt/reports/generate-daily-report.sh
sudo /opt/reports/generate-weekly-report.sh
sudo /opt/reports/generate-monthly-report.sh

# View report files
ls -la /opt/reports/
```

#### Monitor System Health

```bash
# Check resource usage
htop
df -h
free -h

# Monitor Docker containers
docker stats

# Check security alerts
sudo tail -f /var/log/fail2ban.log
```

#### Log Management

```bash
# Download logs securely
ansible-playbook playbooks/download_logs_secure.yml

# View system logs
sudo journalctl -f
sudo tail -f /var/log/syslog

# Check Docker logs
docker logs container-name
```

## Troubleshooting

### 1. Common Issues

#### Vault Decryption Errors

```bash
# Verify vault password
ansible-vault view secrets/vault.yml

# Re-encrypt if needed
ansible-vault rekey secrets/vault.yml
```

#### SSH Connection Issues

```bash
# Test SSH connectivity
ssh -i ~/.ssh/your-key user@server

# Check SSH configuration
ansible all -m shell -a "sudo sshd -T"
```

#### Docker Network Issues

```bash
# Check Docker networks
docker network ls
docker network inspect web-network

# Restart Docker service
sudo systemctl restart docker
```

### 2. Debugging

#### Verbose Ansible Execution

```bash
# Enable verbose output
ansible-playbook -vvv playbooks/full.yml

# Debug specific tasks
ansible-playbook -vvv --tags "configure_firewall" playbooks/full.yml
```

#### Check Role Execution

```bash
# Test role syntax
ansible-playbook --syntax-check playbooks/full.yml

# Dry run
ansible-playbook --check playbooks/full.yml
```

### 3. Recovery Procedures

#### Rollback Deployment

```bash
# Revert to previous configuration
ansible-playbook --tags "configure_firewall" playbooks/full.yml -e "configure_firewall_default_policy=ACCEPT"

# Restore from backup
sudo cp /etc/ufw/user.rules.backup /etc/ufw/user.rules
sudo ufw reload
```

#### Emergency Access

```bash
# If SSH access is lost, use console access
# Reset SSH configuration
sudo nano /etc/ssh/sshd_config
sudo systemctl restart sshd
```

## Maintenance

### 1. Regular Maintenance

#### System Updates maintenance

```bash
# Run system updates
ansible-playbook --tags "update_ubuntu" playbooks/full.yml
```

#### Security Updates

```bash
# Configure automatic security updates
ansible-playbook --tags "configure_security_updates" playbooks/full.yml
```

#### Log Cleanup

```bash
# Clean up old logs
ansible-playbook --tags "configure_log_rotation" playbooks/full.yml
```

### 2. Monitoring Maintenance

#### Check Monitoring Status

```bash
# Verify monitoring services
sudo systemctl status prometheus-node-exporter
sudo systemctl status cron

# Check monitoring logs
sudo tail -f /var/log/monitoring/*.log
```

#### Update Monitoring Configuration

```bash
# Update monitoring settings
ansible-playbook --tags "configure_monitoring" playbooks/full.yml
```

### 3. Backup Procedures

#### Configuration Backup

```bash
# Backup Ansible configuration
tar -czf ansible-config-backup-$(date +%Y%m%d).tar.gz src/

# Backup vault files
cp secrets/vault.yml secrets/vault.yml.backup
cp secrets/.vault_pass secrets/.vault_pass.backup
```

#### System Backup

```bash
# Backup important system files
sudo tar -czf system-config-backup-$(date +%Y%m%d).tar.gz /etc/ssh/ /etc/ufw/ /etc/fail2ban/
```

This deployment guide now reflects the current unified environment structure with vault-based configuration management and comprehensive monitoring and reporting capabilities.
