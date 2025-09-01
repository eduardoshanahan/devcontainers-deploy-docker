# Frequently Asked Questions (FAQ)

## Table of Contents

1. [General Questions](#general-questions)
2. [Installation and Setup](#installation-and-setup)
3. [Configuration](#configuration)
4. [Security](#security)
5. [Docker and Networking](#docker-and-networking)
6. [Monitoring and Reporting](#monitoring-and-reporting)
7. [Troubleshooting](#troubleshooting)
8. [Development](#development)
9. [Performance](#performance)
10. [Maintenance](#maintenance)
11. [Advanced Topics](#advanced-topics)

## General Questions

### What is this project?

This is an Ansible-based infrastructure automation project that automates the deployment and configuration of Ubuntu VPS servers with Docker, security hardening, monitoring, and comprehensive reporting. It provides a complete solution for setting up production-ready servers with containerized applications.

### What are the main features?

- **Ansible Automation**: Complete server deployment and configuration
- **Docker Integration**: Container installation and network management
- **Security Hardening**: SSH, firewall, and container security with Trivy scanning
- **Network Segmentation**: Isolated Docker networks for different services
- **Monitoring**: System health monitoring and alerting
- **Reporting**: Automated system reports with email delivery
- **Log Management**: Secure log collection and analysis
- **DevContainer**: Consistent development environment

### What operating systems are supported?

- **Target Servers**: Ubuntu 22.04 LTS (recommended), Ubuntu 20.04 LTS
- **Development Environment**: Linux, macOS, Windows with WSL2
- **Container Platform**: Docker with Ubuntu base images

### Is this project production-ready?

Yes, this project is designed for production use with:

- Comprehensive security features including container vulnerability scanning
- Network isolation and segmentation
- Monitoring and alerting systems with automated reporting
- Backup and recovery procedures
- Secure log management and analysis
- Extensive testing and validation

### How does this compare to other automation tools?

**Advantages**:

- **Ansible-based**: Declarative, idempotent, and agentless
- **Security-focused**: Built-in security hardening, monitoring, and container scanning
- **Container-native**: Designed for Docker and containerized applications
- **Development-friendly**: DevContainer integration for consistent development
- **Comprehensive**: Complete solution from server setup to application deployment
- **Reporting**: Automated system reports with beautiful HTML formatting
- **Log Management**: Secure log collection and analysis capabilities

## Installation and Setup

### What are the prerequisites?

- **Docker**: For running the development container
- **Git**: For version control
- **SSH Keys**: For secure server access
- **Ubuntu VPS**: Target server for deployment
- **VS Code** or **Cursor**: For development (recommended)
- **Gmail Account**: For email notifications and reporting (optional)

### How do I get started?

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd ansible-docker-deployment
   ```

2. **Configure environment**:

   ```bash
   cp .devcontainer/config/.env.example .devcontainer/config/.env
   nano .devcontainer/config/.env
   ```

3. **Configure server secrets**:

   ```bash
   cd secrets
   cp vault.example.yml vault.yml
   nano vault.yml  # Add your server details
   ansible-vault encrypt vault.yml
   echo "your-vault-password" > .vault_pass
   chmod 600 .vault_pass
   ```

4. **Launch development environment**:

   ```bash
   chmod +x launch.sh
   ./launch.sh
   ```

5. **Deploy the system**:

   ```bash
   ./scripts/deploy-full.sh
   ```

### How do I configure my server details?

The project now uses a unified environment configuration with Ansible Vault for secure secrets management:

1. **Edit the vault file** (`secrets/vault.yml`):

   ```yaml
   # Server Configuration
   vault_vps_server_ip: "your-vps-server-ip-or-hostname.com"
   vault_initial_deployment_user: "ubuntu"
   vault_initial_deployment_ssh_key: "~/.ssh/your-initial-deployment-key"
   
   # Email Configuration
   vault_configure_security_updates_email: "admin@yourdomain.com"
   vault_configure_security_updates_gmail_user: "your-email@gmail.com"
   vault_configure_security_updates_gmail_password: "your-gmail-app-password"
   ```

2. **Encrypt the vault file**:

   ```bash
   ansible-vault encrypt secrets/vault.yml
   ```

3. **Set up environment variables** (`secrets/.env`):

   ```bash
   ANSIBLE_VAULT_PASSWORD_FILE=secrets/.vault_pass
   ANSIBLE_VAULT_FILE=secrets/vault.yml
   ANSIBLE_CONFIG=src/ansible.cfg
   ```

### How do I handle different environments?

The project now uses a **unified environment configuration** approach:

- **Single Configuration**: All settings in `src/inventory/group_vars/all/main.yml`
- **Secure Secrets**: Sensitive data encrypted in `secrets/vault.yml`
- **Environment Overrides**: Use environment variables for development-specific settings
- **Simplified Management**: No more separate production/staging/development files

For development overrides:

```bash
# Disable host key checking for development
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml

# Enable verbose output
ANSIBLE_VERBOSITY=2 ansible-playbook playbooks/full.yml
```

## Configuration

### How do I customize the deployment?

You can customize the deployment in several ways:

1. **Edit main configuration** (`src/inventory/group_vars/all/main.yml`):

   ```yaml
   # Docker network configuration
   configure_docker_networks_custom_networks:
     - name: "api-network"
       subnet: "172.23.0.0/16"
       driver: "bridge"
   
   # Monitoring thresholds
   configure_monitoring_disk_threshold: 85
   configure_monitoring_memory_threshold: 90
   ```

2. **Override variables during deployment**:

   ```bash
   ansible-playbook playbooks/full.yml -e "configure_firewall_ssh_port=2222"
   ```

3. **Use tags for selective deployment**:

   ```bash
   # Deploy only Docker
   ansible-playbook --tags "deploy_docker" playbooks/full.yml
   
   # Skip monitoring
   ansible-playbook --skip-tags "configure_monitoring" playbooks/full.yml
   ```

### How do I configure email notifications?

Email notifications are configured through the vault file:

```yaml
# In secrets/vault.yml
vault_configure_security_updates_email: "admin@yourdomain.com"
vault_configure_security_updates_gmail_user: "your-email@gmail.com"
vault_configure_security_updates_gmail_password: "your-gmail-app-password"
vault_configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
vault_configure_security_updates_gmail_smtp_port: "465"

# For reporting
vault_configure_reporting_email: "reports@yourdomain.com"
vault_configure_reporting_gmail_user: "your-email@gmail.com"
vault_configure_reporting_gmail_password: "your-gmail-app-password"
```

**Note**: Use Gmail App Passwords, not your regular Gmail password.

### How do I configure Docker networks?

Docker networks are configured in the main configuration file:

```yaml
# In src/inventory/group_vars/all/main.yml
configure_docker_networks_default_networks:
  - name: "web-network"
    subnet: "172.20.0.0/16"
    driver: "bridge"
    description: "Web applications network"
  - name: "db-network"
    subnet: "172.21.0.0/16"
    driver: "bridge"
    description: "Database network"
  - name: "monitoring-network"
    subnet: "172.22.0.0/16"
    driver: "bridge"
    description: "Monitoring network"

# Add custom networks
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
    description: "API services network"
```

## Security

### What security features are included?

The project includes comprehensive security features:

- **SSH Security**: Key-based authentication, password disabled, root login disabled
- **Firewall**: UFW with default deny policy and specific allow rules
- **Fail2ban**: Intrusion prevention and brute force protection
- **Container Security**: Trivy vulnerability scanning for all Docker images
- **Network Segmentation**: Isolated Docker networks with controlled access
- **Ansible Vault**: Encrypted sensitive configuration data
- **Log Security**: Encrypted log archives and secure log collection

### How do I configure container security scanning?

Container security scanning is configured in the main configuration:

```yaml
# In src/inventory/group_vars/all/main.yml
configure_container_security_enabled: true
configure_container_security_trivy_enabled: true
configure_container_security_alerts_enabled: true
configure_container_security_alert_email: "security@yourdomain.com"
configure_container_security_scan_images: true
configure_container_security_scan_running: true
configure_container_security_scan_schedule: "0 2 * * *"
configure_container_security_severity_threshold: "HIGH"
```

### How do I manage sensitive data?

Sensitive data is managed using Ansible Vault:

```bash
# Encrypt sensitive data
ansible-vault encrypt secrets/vault.yml

# Edit encrypted file
ansible-vault edit secrets/vault.yml

# View encrypted file
ansible-vault view secrets/vault.yml

# Change vault password
ansible-vault rekey secrets/vault.yml
```

### How do I test security configurations?

You can test security configurations using the provided playbooks:

```bash
# Test network security
ansible-playbook playbooks/test_network_security.yml

# Test container security
ansible-playbook playbooks/test_container_security.yml

# Test firewall configuration
ansible all -m shell -a "sudo ufw status verbose"
```

## Docker and Networking

### How do I deploy applications with Docker?

Use the secure Docker Compose template:

```bash
# Copy the secure template
cp examples/docker-compose.secure.yml your-app/docker-compose.yml

# Customize for your application
nano your-app/docker-compose.yml

# Deploy with network segmentation
docker-compose up -d
```

### How do I configure custom Docker networks?

Add custom networks to the configuration:

```yaml
# In src/inventory/group_vars/all/main.yml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
    description: "API services network"
  - name: "cache-network"
    subnet: "172.24.0.0/16"
    driver: "bridge"
    description: "Cache services network"
```

### How do I test network connectivity?

Test network connectivity between containers:

```bash
# Test web to database connectivity
docker run --rm --network web-network alpine ping db-network

# Test network isolation
docker run --rm --network web-network alpine ping 172.21.0.1
```

## Monitoring and Reporting

### What monitoring is included?

The project includes comprehensive monitoring:

- **System Monitoring**: CPU, memory, disk usage (every 2 minutes)
- **Service Monitoring**: Docker containers, system services (every 5 minutes)
- **Security Monitoring**: Failed logins, network anomalies
- **Container Security**: Trivy vulnerability scanning with alerts
- **Resource Monitoring**: Prometheus Node Exporter (optional)

### How do I configure monitoring thresholds?

Configure monitoring thresholds in the main configuration:

```yaml
# In src/inventory/group_vars/all/main.yml
configure_monitoring_disk_threshold: 80
configure_monitoring_memory_threshold: 85
configure_monitoring_cpu_threshold: 90
configure_monitoring_retention_days: 30
```

### How do I access system reports?

System reports are automatically generated and can be accessed manually:

```bash
# Generate manual reports
sudo /opt/reports/generate-daily-report.sh
sudo /opt/reports/generate-weekly-report.sh
sudo /opt/reports/generate-monthly-report.sh

# View report files
ls -la /opt/reports/

# Test email delivery
sudo /opt/reports/email-report.sh daily /opt/reports/daily_report_*.html
```

### How do I configure report schedules?

Report schedules are configured in the reporting role:

- **Daily Reports**: 6:00 AM daily
- **Weekly Reports**: Sunday 7:00 AM
- **Monthly Reports**: 1st of month 8:00 AM

You can modify these schedules by editing the cron jobs:

```bash
# View current cron jobs
sudo crontab -l

# Edit cron jobs
sudo crontab -e
```

## Troubleshooting

### What if the deployment fails?

1. **Check prerequisites**:

   ```bash
   # Verify vault configuration
   ansible-vault view secrets/vault.yml
   
   # Check SSH connectivity
   ssh -i ~/.ssh/your-key user@server
   
   # Verify environment variables
   echo $ANSIBLE_VAULT_PASSWORD_FILE
   ```

2. **Run with verbose output**:

   ```bash
   ansible-playbook -vvv playbooks/full.yml
   ```

3. **Check specific roles**:

   ```bash
   # Test individual roles
   ansible-playbook --check --tags "update_ubuntu" playbooks/full.yml
   ansible-playbook --check --tags "configure_firewall" playbooks/full.yml
   ```

### What if SSH access is lost?

If SSH access is lost due to security configuration:

1. **Use console access** to the server
2. **Reset SSH configuration**:

   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set PasswordAuthentication yes temporarily
   sudo systemctl restart sshd
   ```

3. **Re-run the deployment** with corrected settings

### What if Docker networks aren't working?

1. **Check Docker service**:

   ```bash
   sudo systemctl status docker
   sudo systemctl restart docker
   ```

2. **Verify network configuration**:

   ```bash
   docker network ls
   docker network inspect web-network
   ```

3. **Recreate networks**:

   ```bash
   ansible-playbook --tags "configure_docker_networks" playbooks/full.yml
   ```

### What if monitoring isn't working?

1. **Check monitoring services**:

   ```bash
   sudo systemctl status prometheus-node-exporter
   sudo systemctl status cron
   ```

2. **Check monitoring logs**:

   ```bash
   sudo tail -f /var/log/monitoring/*.log
   ```

3. **Reconfigure monitoring**:

   ```bash
   ansible-playbook --tags "configure_monitoring" playbooks/full.yml
   ```

## Development

### How do I use the development environment?

1. **Launch the DevContainer**:

   ```bash
   chmod +x launch.sh
   ./launch.sh
   ```

2. **The container includes**:
   - Ansible 9.2.0 with linting
   - Docker CLI tools
   - SSH agent with key management
   - VS Code extensions for Ansible, YAML, Docker

### How do I test changes?

1. **Syntax check**:

   ```bash
   ansible-playbook --syntax-check playbooks/full.yml
   ```

2. **Dry run**:

   ```bash
   ansible-playbook --check playbooks/full.yml
   ```

3. **Test specific roles**:

   ```bash
   ansible-playbook --check --tags "configure_firewall" playbooks/full.yml
   ```

### How do I add new roles?

1. **Create role structure**:

   ```bash
   mkdir -p src/roles/new_role/{tasks,handlers,defaults,vars,meta,templates}
   touch src/roles/new_role/tasks/main.yml
   ```

2. **Add to main playbook**:

   ```yaml
   # In playbooks/full.yml
   roles:
     - new_role
   ```

3. **Test the role**:

   ```bash
   ansible-playbook --check --tags "new_role" playbooks/full.yml
   ```

## Performance

### What are the resource requirements?

**Target Server (2GB RAM VPS)**:

| Component | RAM Usage | CPU Usage | Status |
|-----------|-----------|-----------|---------|
| **Prometheus Node Exporter** | ~50MB | ~0.1 cores | Running |
| **Container Security (Trivy)** | ~100MB | ~0.2 cores | Active |
| **Monitoring Scripts** | ~50MB | ~0.1 cores | Active |
| **Reporting System** | ~50MB | ~0.1 cores | Active |
| **Security Tools** | ~100MB | ~0.1 cores | Active |
| **Total Monitoring** | ~350MB | ~0.6 cores | Optimized |
| **Available for Applications** | ~1.65GB | ~1.4 cores | Ready |

### How do I optimize performance?

1. **Adjust monitoring intervals**:

   ```yaml
   # In src/inventory/group_vars/all/main.yml
   configure_monitoring_health_check_interval: 600  # 10 minutes
   configure_monitoring_resource_check_interval: 300  # 5 minutes
   ```

2. **Disable unused features**:

   ```yaml
   configure_monitoring_prometheus_enabled: false
   configure_remote_logging_enabled: false
   ```

3. **Optimize log retention**:

   ```yaml
   configure_log_rotation_retention_days: 3
   configure_log_download_retention_days: 3
   ```

## Maintenance

### How do I update the system?

1. **System updates**:

   ```bash
   ansible-playbook --tags "update_ubuntu" playbooks/full.yml
   ```

2. **Security updates**:

   ```bash
   ansible-playbook --tags "configure_security_updates" playbooks/full.yml
   ```

3. **Docker updates**:

   ```bash
   ansible-playbook --tags "deploy_docker" playbooks/full.yml
   ```

### How do I backup the configuration?

1. **Backup Ansible configuration**:

   ```bash
   tar -czf ansible-config-backup-$(date +%Y%m%d).tar.gz src/
   ```

2. **Backup vault files**:

   ```bash
   cp secrets/vault.yml secrets/vault.yml.backup
   cp secrets/.vault_pass secrets/.vault_pass.backup
   ```

3. **Backup system configuration**:

   ```bash
   sudo tar -czf system-config-backup-$(date +%Y%m%d).tar.gz /etc/ssh/ /etc/ufw/ /etc/fail2ban/
   ```

### How do I clean up old logs?

1. **Automatic cleanup** (configured by default):

   ```bash
   # Check log rotation status
   sudo logrotate -d /etc/logrotate.conf
   ```

2. **Manual cleanup**:

   ```bash
   # Clean up old Docker logs
   sudo find /var/lib/docker/containers -name "*.log" -mtime +7 -delete
   
   # Clean up old reports
   sudo find /opt/reports -name "*.html" -mtime +30 -delete
   ```

## Advanced Topics

### How do I scale to multiple servers?

1. **Add servers to inventory** (`src/inventory/hosts.yml`):

   ```yaml
   all:
     hosts:
       vps1:
         ansible_host: "server1.example.com"
       vps2:
         ansible_host: "server2.example.com"
       vps3:
         ansible_host: "server3.example.com"
   ```

2. **Use parallel execution**:

   ```bash
   ansible-playbook playbooks/full.yml -f 10
   ```

### How do I integrate with CI/CD?

1. **GitHub Actions example**:

   ```yaml
   name: Deploy to Server
   on:
     push:
       branches: [main]
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v2
         - name: Deploy with Ansible
           run: |
             echo "${{ secrets.VAULT_PASSWORD }}" > secrets/.vault_pass
             chmod 600 secrets/.vault_pass
             ansible-playbook playbooks/full.yml
   ```

### How do I customize the reporting system?

1. **Modify report templates**:

   ```bash
   sudo nano /opt/reports/templates/daily-report.html
   ```

2. **Add custom metrics**:

   ```bash
   sudo nano /opt/reports/generate-daily-report.sh
   ```

3. **Configure custom schedules**:

   ```bash
   sudo crontab -e
   # Add custom cron jobs
   ```

### How do I implement disaster recovery?

1. **Regular backups**:

   ```bash
   # Automated backup script
   #!/bin/bash
   tar -czf backup-$(date +%Y%m%d).tar.gz src/ secrets/
   scp backup-*.tar.gz backup-server:/backups/
   ```

2. **Configuration versioning**:

   ```bash
   # Tag important configurations
   git tag -a v1.0.0 -m "Production configuration"
   git push origin v1.0.0
   ```

3. **Recovery procedures**:

   ```bash
   # Restore from backup
   tar -xzf backup-20231201.tar.gz
   ansible-vault decrypt secrets/vault.yml
   ansible-playbook playbooks/full.yml
   ```

This FAQ now reflects the current unified environment structure with vault-based configuration management, comprehensive monitoring and reporting capabilities, and all the new features that have been added to the project.
