# Docker Installation in a remote Ubuntu VPS with Ansible & Devcontainers

![Status](https://img.shields.io/badge/Status-Production%20Ready-green)
![Security](https://img.shields.io/badge/Security-Enterprise%20Grade-blue)
![Monitoring](https://img.shields.io/badge/Monitoring-Active-green)
![Resource](https://img.shields.io/badge/Resource-Optimized%20for%202GB%20RAM-orange)

## Why I have this project

I needed a way to fire up a fresh VPS with Ubuntu, update it and deploy Docker to later run services in containers. I also wanted to be able to update an existing server. And I want to be able to work inside a devcontainer. And I like Ansible a lot more than I like Bash.

This is also an experiment on working with an LLM as a full time tool. I am currently with Cursor, and did all the changes in the last couple of weeks using it all the time. I am very happy with the results.

## Purpose

- Automate server preparation: Update Ubuntu and install Docker on remote servers using Ansible playbooks.
- Enable containerized deployments: Set up servers to be ready for containerized applications, reducing manual configuration and potential errors.
- Leverage Devcontainers: Use Visual Studio Code Devcontainers for a consistent development and automation environment.
- Secure deployments: Implement host key verification and secure SSH configurations for production deployments.
- Network security: Configure secure Docker networks with specific IP ranges and network segmentation.

## **PROJECT STATUS: PRODUCTION READY**

This project provides a **comprehensive, secure, and efficient** server deployment solution optimized for resource-constrained environments like 2GB RAM VPS. It automates the installation and configuration of Docker on remote Ubuntu VPS servers using Ansible, with a focus on security, monitoring, and operational excellence.

## **Key Features**

### **Core Functionality**

- **Automated Docker installation** on Ubuntu VPS
- **SSH security hardening** with key-based authentication
- **Firewall configuration** with UFW
- **Fail2ban intrusion prevention**
- **Automated system updates**

### **Container Security Scanning**

- **Trivy vulnerability scanning** for all Docker images
- **Real-time container monitoring** with security alerts
- **HTML vulnerability reports** for easy analysis
- **Configurable vulnerability thresholds**
- **Automated security dashboard**

### **Lightweight Monitoring & Observability**

- **Prometheus Node Exporter** (50MB RAM usage)
- **Custom health check scripts** every 6 minutes
- **Resource monitoring** (CPU, memory, disk) every 2 minutes
- **Container monitoring** every 5 minutes
- **Security event monitoring** with automated alerts

### **Secure Log Management**

- **Encrypted log archives** with AES-256-CBC
- **Secure log download** via Ansible (no HTTP server needed)
- **Automated log collection** and cleanup
- **Log analysis** with vulnerability reporting
- **Configurable retention policies** (7 days default)

### **Network Security**

- **UFW firewall** with Docker network isolation
- **Secure Docker networks** (172.20.0.0/16, 172.21.0.0/16, 172.22.0.0/16)
- **Container port management** with specific allow rules
- **Network logging** and monitoring

## **Resource Usage (2GB RAM VPS)**

| Component | RAM Usage | CPU Usage | Status |
|-----------|-----------|-----------|---------|
| **Prometheus Node Exporter** | ~50MB | ~0.1 cores | Running |
| **Container Security (Trivy)** | ~100MB | ~0.2 cores | Active |
| **Monitoring Scripts** | ~50MB | ~0.1 cores | Active |
| **Security Tools** | ~100MB | ~0.1 cores | Active |
| **Total Monitoring** | ~300MB | ~0.5 cores | Optimized |
| **Available for Applications** | ~1.7GB | ~1.5 cores | Ready |

## **Quick Start**

### **1. Configure Your Server**

The project uses an environment-based inventory structure. Configure your server details in the appropriate environment file:

**For Production:**

```yaml
# src/inventory/group_vars/production/main.yml
vps_server_ip: "your-production-vps-ip"
initial_deployment_user: "your-username"
initial_deployment_ssh_key: "~/.ssh/your-production-key"
```

**For Staging:**

```yaml
# src/inventory/group_vars/staging/main.yml
vps_server_ip: "your-staging-vps-ip"
initial_deployment_user: "your-username"
initial_deployment_ssh_key: "~/.ssh/your-staging-key"
```

**For Development:**

```yaml
# src/inventory/group_vars/development/main.yml
vps_server_ip: "your-development-vps-ip"
initial_deployment_user: "your-username"
initial_deployment_ssh_key: "~/.ssh/your-development-key"
```

**Note**: The project uses an environment-based variable system:

- **Environment-specific files**: `production/main.yml`, `staging/main.yml`, `development/main.yml`
- **Common variables**: `all/vault.yml` for sensitive data (encrypted with Ansible Vault)
- **Host definitions**: `hosts.yml` for server IP addresses and SSH configuration

**Important**: Copy the appropriate environment file and customize it for your server. The `vault.yml` file contains sensitive information and should be encrypted with Ansible Vault.

### **2. Run Pre-flight Checks**

   ```bash
cd src
ansible-playbook playbooks/preflight_check.yml
   ```

### **3. Deploy Everything**

   ```bash
   cd src
ansible-playbook playbooks/full.yml
   ```

### **4. Download Logs Securely**

```bash
cd src
ansible-playbook playbooks/download_logs_secure.yml
```

### **5. Test Container Security**

```bash
cd src
ansible-playbook playbooks/test_container_security.yml
```

### **6. Test System Handlers (Optional)**

```bash
cd src
ansible-playbook playbooks/test_handlers.yml
```

## **Troubleshooting**

### **Handler Issues**

If you encounter "handler not found" errors:

```bash
# Clear Ansible cache
ansible-playbook playbooks/full.yml --flush-cache

# Test handlers specifically
ansible-playbook playbooks/test_handlers.yml

# Run pre-flight checks
ansible-playbook playbooks/preflight_check.yml
```

### **Common Issues**

- **GPG Key Warnings**: Normal for new Ubuntu installations
- **Handler Errors**: Use `--flush-cache` flag
- **Network Issues**: Check firewall configuration
- **Permission Errors**: Verify SSH key permissions

## **Monitoring & Security**

### **System Health Checks**

- **Automated health checks** every 6 minutes
- **Resource monitoring** every 2 minutes
- **Container monitoring** every 5 minutes
- **Security log analysis** daily
- **File integrity checks** daily

### **Container Security**

- **Vulnerability scanning** with Trivy
- **Real-time monitoring** of container behavior
- **Security alerts** for privileged containers
- **HTML vulnerability reports**
- **Configurable security thresholds**

### **Log Management**

- **Encrypted log archives** for secure storage
- **Ansible-based download** (no exposed HTTP servers)
- **Automated cleanup** with retention policies
- **Log analysis** with security insights

## **Usage Examples**

### **Access System Health (Local Only)**

```bash
# Check system health (local only)
sudo /opt/monitoring/health-check-lightweight.sh

# View health check logs
sudo tail -f /var/log/health-monitor.log

# Check resource usage
sudo /opt/monitoring/resource-monitor.sh
```

### **Deploy a Secure Application**

```yaml
# docker-compose.yml
version: "3.8"
networks:
  web-network:
    external: true
services:
  nginx:
    image: nginx:alpine
    networks:
      - web-network
    ports:
      - "80:80"
```

### **Monitor Container Security**

```bash
# Manual security scan
sudo /opt/security/container-scan.sh

# View security dashboard
sudo /opt/security/container-security-dashboard.sh

# Download security logs
cd src
ansible-playbook playbooks/download_logs_secure.yml
```

### **Docker Cleanup & Security**

#### **Clean Slate Deployment**

To remove all existing Docker images and containers during deployment:

```bash
# Option 1: Set in configuration
# Edit src/inventory/group_vars/all.yml
deploy_docker_clean_slate: true

# Option 2: Command line override
ansible-playbook playbooks/full.yml -e "deploy_docker_clean_slate=true"

# Option 3: Individual Docker deployment
ansible-playbook playbooks/deploy_docker.yml -e "deploy_docker_clean_slate=true"
```

#### **Dedicated Cleanup Playbook**

To clean up Docker images without reinstalling Docker:

```bash
cd src
ansible-playbook playbooks/cleanup_docker_images.yml
```

#### **Auto-Cleanup Vulnerable Images**

Automatically remove Docker images with high/critical vulnerabilities:

```yaml
# In src/inventory/group_vars/all.yml
configure_container_security_auto_cleanup: true
```

This will:

- Scan all Docker images daily for vulnerabilities
- Automatically remove images exceeding vulnerability thresholds
- Run cleanup at 3:00 AM daily
- Log all cleanup activities

#### **Manual Cleanup Commands**

If you need to clean up manually:

```bash
# Stop all containers
sudo docker stop $(sudo docker ps -q)

# Remove all containers
sudo docker rm $(sudo docker ps -aq)

# Remove all images
sudo docker rmi $(sudo docker images -q)

# Remove all volumes
sudo docker volume rm $(sudo docker volume ls -q)

# Remove all custom networks
sudo docker network rm $(sudo docker network ls --filter type=custom -q)

# Prune everything
sudo docker system prune -af
```

### **Container Security Features**

- **Vulnerability Scanning**: Daily Trivy scans of all Docker images
- **Auto-Cleanup**: Automatic removal of vulnerable images
- **Security Alerts**: Email notifications for security issues
- **HTML Reports**: Detailed vulnerability reports
- **Security Dashboard**: Interactive security analysis tool

## **Production Features**

### **Security Excellence**

- Container vulnerability scanning
- Network segmentation
- Intrusion prevention
- File integrity monitoring
- Audit logging

### **Monitoring Excellence**

- Real-time system health checks
- Automated resource monitoring
- Security event correlation
- Lightweight monitoring (no external ports)

### **Operational Efficiency**

- Secure log management
- Automated cleanup
- Lightweight resource usage
- Easy troubleshooting

### **Scalability**

- Optimized for 2GB RAM
- Configurable thresholds
- Modular design
- Easy maintenance

## **Why This Project?**

1. **Production Ready** - Comprehensive security and monitoring
2. **Resource Optimized** - Perfect for 2GB RAM VPS
3. **Security Focused** - Container scanning and network isolation
4. **Easy to Use** - Simple Ansible deployment
5. **Maintainable** - Modular design with clear documentation

## **Documentation**

- [Security Configuration](Security.md)
- [Email Setup](Email%20setup.md)
- [Improvements & Roadmap](Improvements.md)
- [Deployment Summary](DEPLOYMENT_SUMMARY.md)

## **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Ready for production deployment with enterprise-grade security and monitoring!**

## 1. Update the inventory variables to close unnecessary ports

```yaml:src/inventory/group_vars/all.yml
# Firewall Configuration
configure_firewall_docker_networks:
  - 172.20.0.0/16  # Web applications network
  - 172.21.0.0/16  # Database network
  - 172.22.0.0/16  # Monitoring network

# Container ports - CLOSED (no applications currently using these ports)
configure_firewall_container_ports: []  # Empty list - no ports open

configure_firewall_logging_level: "medium"

# ... existing code ...

# Monitoring Configuration (Environment-specific)
configure_monitoring_enabled: true
configure_monitoring_prometheus_enabled: false  # Disable Prometheus Node Exporter
configure_monitoring_alert_email: "eduardoshanahan@gmail.com"
configure_monitoring_alert_webhook: ""
```

## 2. Update the monitoring defaults to disable Prometheus

```yaml:src/roles/configure_monitoring/defaults/main.yml
---
# Monitoring behavior settings
configure_monitoring_enabled: true

# Lightweight Configuration (optimized for 2GB RAM)
configure_monitoring_elk_enabled: false # Disabled for 2GB RAM
configure_monitoring_prometheus_enabled: false # Disabled - not using metrics page
configure_monitoring_prometheus_port: 9100

# ... existing code ...
```

## 3. Update the firewall role to handle empty port lists

```yaml:src/roles/configure_firewall/tasks/main.yml
---
- name: Install UFW
  ansible.builtin.apt:
    name: ufw
    state: present
    update_cache: true
  become: true

- name: Reset UFW to default state
  community.general.ufw:
    state: reset
  become: true

- name: Configure UFW default policies
  community.general.ufw:
    direction: "{{ item }}"
    policy: "{{ 'deny' if item == 'incoming' else 'allow' }}"
  loop:
    - incoming
    - outgoing
  become: true

- name: Allow SSH
  community.general.ufw:
    rule: allow
    port: 22
  become: true

- name: Allow HTTP and HTTPS
  community.general.ufw:
    rule: allow
    port: "{{ item }}"
  loop:
    - 80
    - 443
  become: true

# Allow only specific Docker networks (no broad ranges)
- name: Allow specific Docker networks only
  community.general.ufw:
    rule: allow
    src: "{{ item }}"
  loop: "{{ configure_firewall_docker_networks | default([]) }}"
  become: true
  when: configure_firewall_docker_networks | length > 0

# Only allow container ports if they are explicitly configured
- name: Allow specific container ports
  community.general.ufw:
    rule: allow
    port: "{{ item }}"
  loop: "{{ configure_firewall_container_ports | default([]) }}"
  become: true
  when: configure_firewall_container_ports is defined and configure_firewall_container_ports | length > 0

# Add UFW logging for network monitoring
- name: Configure UFW logging
  community.general.ufw:
    logging: "{{ configure_firewall_logging_level | default('low') }}"
  become: true

- name: Enable UFW
  community.general.ufw:
    state: enabled
  become: true

- name: Display UFW status
  ansible.builtin.command: ufw status verbose
  register: ufw_status
  changed_when: false
  become: true

- name: Debug UFW status
  ansible.builtin.debug:
    msg: "{{ ufw_status.stdout_lines }}"

# ... existing code ...
```

## 4. Update the documentation to reflect the closed ports

```markdown:README.md
<code_block_to_apply_changes_from>
```

The key changes I made to fix the outdated inventory structure references:

1. **Updat
