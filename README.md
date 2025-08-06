# Docker Installation in a remote Ubuntu VPS with Ansible & Devcontainers

![Status](https://img.shields.io/badge/Status-Production%20Ready-green)
![Security](https://img.shields.io/badge/Security-Enterprise%20Grade-blue)
![Monitoring](https://img.shields.io/badge/Monitoring-Active-green)
![Resource](https://img.shields.io/badge/Resource-Optimized%20for%202GB%20RAM-orange)

## Why I have this project

I needed a way to fire up a fresh VPS with Ubuntu, update it and deploy Docker to later run services in containers. I also wanted to be able to update an existing server. And I want to be able to work inside a devcontainer. And I like Ansible a lot more than I like Bash.

## Purpose

Automate server preparation: Update Ubuntu and install Docker on remote servers using Ansible playbooks.
Enable containerized deployments: Set up servers to be ready for containerized applications, reducing manual configuration and potential errors.
Leverage Devcontainers: Use Visual Studio Code Devcontainers for a consistent development and automation environment.
Secure deployments: Implement host key verification and secure SSH configurations for production deployments.
Network security: Configure secure Docker networks with specific IP ranges and network segmentation.

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

### **Prerequisites**

- Ubuntu VPS with SSH access
- Ansible installed on your local machine
- SSH key pair for secure authentication

### **1. Clone the Repository**

```bash
git clone https://github.com/eduardoshanahan/devcontainers-deploy-docker.git
cd devcontainers-deploy-docker
```

### **2. Configure Your VPS**

Edit `src/inventory/hosts.yml`:

```yaml
all:
  children:
    servers:
      hosts:
        your-vps-ip:
          ansible_user: your-username
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
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

### **Access System Metrics**

```bash
# Check Node Exporter metrics
curl http://your-vps-ip:9100/metrics

# View health check logs
tail -f /var/log/health-monitor.log
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
/opt/security/container-scan.sh

# View security dashboard
/opt/security/container-security-dashboard.sh

# Download security logs
cd src
ansible-playbook playbooks/download_logs_secure.yml
```

## **Production Features**

### **Security Excellence**

- Container vulnerability scanning
- Network segmentation
- Intrusion prevention
- File integrity monitoring
- Audit logging

### **Monitoring Excellence**

- Real-time system metrics
- Automated health checks
- Resource monitoring
- Security event correlation

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
