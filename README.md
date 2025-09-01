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
- Comprehensive monitoring: Automated system reporting and security monitoring with email notifications.

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

### **Automated Reporting System**

- **Daily system reports** with email delivery
- **Weekly trend analysis** with statistics
- **Monthly comprehensive reports** with long-term trends
- **Security vulnerability reports** with HTML formatting
- **Gmail SMTP integration** for secure email delivery

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
| **Reporting System** | ~50MB | ~0.1 cores | Active |
| **Security Tools** | ~100MB | ~0.1 cores | Active |
| **Total Monitoring** | ~350MB | ~0.6 cores | Optimized |
| **Available for Applications** | ~1.65GB | ~1.4 cores | Ready |

## **Quick Start**

### **1. Configure Your Server**

The project uses a **unified environment configuration** with Ansible Vault for secure secrets management:

#### **Set Up Secrets**

```bash
# Navigate to secrets directory
cd secrets

# Copy the example vault file
cp vault.example.yml vault.yml

# Edit the vault file with your server details
nano vault.yml
```

#### **Required Vault Configuration**

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
```

#### **Encrypt the Vault File**

```bash
# Encrypt the vault file
ansible-vault encrypt vault.yml

# Set up vault password file
echo "your-vault-password" > .vault_pass
chmod 600 .vault_pass
```

#### **Configure Environment Variables**

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

### **2. Launch Development Environment**

```bash
# Make launch script executable
chmod +x launch.sh

# Launch the development environment
./launch.sh
```

### **3. Deploy Everything**

#### **Automated Deployment (Recommended)**

```bash
# Navigate to workspace root
cd /workspace

# Run the automated deployment script
./scripts/deploy-full.sh
```

#### **Manual Deployment**

```bash
# Navigate to Ansible directory
cd src

# Run complete deployment
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
- **Vault Decryption Errors**: Check vault password and file permissions

## **Monitoring & Security**

### **System Health Checks**

- **Automated health checks** every 6 minutes
- **Resource monitoring** every 2 minutes
- **Container monitoring** every 5 minutes
- **Security log analysis** daily
- **File integrity checks** daily

### **Automated Reporting**

- **Daily Reports**: System health, security events, resource usage (6:00 AM)
- **Weekly Reports**: Extended analysis with trends and statistics (Sunday 7:00 AM)
- **Monthly Reports**: Comprehensive system analysis with long-term trends (1st of month 8:00 AM)
- **Security Reports**: Vulnerability scans, failed login attempts, security alerts
- **Email Delivery**: Beautiful HTML reports via Gmail SMTP

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

### **Generate System Reports**

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
# Edit src/inventory/group_vars/all/main.yml
deploy_docker_clean_slate: true

# Option 2: Command line override
ansible-playbook playbooks/full.yml -e "deploy_docker_clean_slate=true"

# Option 3: Individual Docker deployment
ansible-playbook --tags "deploy_docker" playbooks/full.yml -e "deploy_docker_clean_slate=true"
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
# In src/inventory/group_vars/all/main.yml
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
- Ansible Vault encryption

### **Monitoring Excellence**

- Real-time system health checks
- Automated resource monitoring
- Security event correlation
- Lightweight monitoring (no external ports)
- Automated reporting system

### **Operational Efficiency**

- Secure log management
- Automated cleanup
- Lightweight resource usage
- Easy troubleshooting
- Email notifications

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
6. **Automated Reporting** - Beautiful HTML reports with email delivery

## **Documentation**

- [Architecture Overview](documentation/ARCHITECTURE.md)
- [Deployment Guide](documentation/DEPLOYMENT%20GUIDE.md)
- [Security Documentation](documentation/SECURITY.md)
- [Roles Documentation](documentation/ROLES.md)
- [FAQ](documentation/FAQ.md)
- [Troubleshooting Guide](documentation/TROUBLESHOOTING.md)
- [Contributing Guide](documentation/CONTRIBUTING.md)

## **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Ready for production deployment with enterprise-grade security, monitoring, and automated reporting!**
