# Frequently Asked Questions (FAQ)

## Table of Contents

1. [General Questions](#general-questions)
2. [Installation and Setup](#installation-and-setup)
3. [Configuration](#configuration)
4. [Security](#security)
5. [Docker and Networking](#docker-and-networking)
6. [Troubleshooting](#troubleshooting)
7. [Development](#development)
8. [Performance](#performance)
9. [Maintenance](#maintenance)
10. [Advanced Topics](#advanced-topics)

## General Questions

### What is this project?

This is an Ansible-based infrastructure automation project that automates the deployment and configuration of Ubuntu VPS servers with Docker, security hardening, and monitoring. It provides a complete solution for setting up production-ready servers with containerized applications.

### What are the main features?

- **Ansible Automation**: Complete server deployment and configuration
- **Docker Integration**: Container installation and network management
- **Security Hardening**: SSH, firewall, and container security
- **Network Segmentation**: Isolated Docker networks for different services
- **Monitoring**: System health monitoring and alerting
- **DevContainer**: Consistent development environment

### What operating systems are supported?

- **Target Servers**: Ubuntu 22.04 LTS (recommended), Ubuntu 20.04 LTS
- **Development Environment**: Linux, macOS, Windows with WSL2
- **Container Platform**: Docker with Ubuntu base images

### Is this project production-ready?

Yes, this project is designed for production use with:

- Comprehensive security features
- Network isolation and segmentation
- Monitoring and alerting systems
- Backup and recovery procedures
- Extensive testing and validation

### How does this compare to other automation tools?

**Advantages**:

- **Ansible-based**: Declarative, idempotent, and agentless
- **Security-focused**: Built-in security hardening and monitoring
- **Container-native**: Designed for Docker and containerized applications
- **Development-friendly**: DevContainer integration for consistent development
- **Comprehensive**: Complete solution from server setup to application deployment

## Installation and Setup

### What are the prerequisites?

- **Docker**: For running the development container
- **Git**: For version control
- **SSH Keys**: For secure server access
- **Ubuntu VPS**: Target server for deployment
- **VS Code** or **Cursor**: For development (recommended)

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

3. **Launch development environment**:

   ```bash
   chmod +x launch.sh
   ./launch.sh
   ```

4. **Configure server inventory**:

   ```bash
   # Copy and customize the appropriate environment file
   cp inventory/group_vars/production/main.yml inventory/group_vars/production/main.yml.backup
   nano inventory/group_vars/production/main.yml
   ```

### How do I configure my server details?

Edit the appropriate environment file in `src/inventory/group_vars/`:

**For Production:**

```yaml
# src/inventory/group_vars/production/main.yml
# Server configuration
vps_server_ip: "your-production-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-production-ssh-key"

# Container deployment user
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-production-deployment-key"
```

**For Staging:**

```yaml
# src/inventory/group_vars/staging/main.yml
# Server configuration
vps_server_ip: "your-staging-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-staging-ssh-key"
```

**For Development:**

```yaml
# src/inventory/group_vars/development/main.yml
# Server configuration
vps_server_ip: "your-development-server-ip"
initial_deployment_user: "ubuntu"
initial_deployment_ssh_key: "~/.ssh/your-development-ssh-key"
```

### How do I add my server's host key?

```bash
# Add server host key
ssh-keyscan -H your-server-ip >> src/inventory/known_hosts

# Verify connection
ssh -o StrictHostKeyChecking=yes your-server-ip
```

### What if I don't have a VPS yet?

You can:

- **Use a cloud provider** (AWS, DigitalOcean, Linode, etc.)
- **Set up a local VM** for testing
- **Use a staging environment** for development
- **Test with Docker containers** locally

## Configuration

### How do I customize the deployment?

You can customize various aspects:

**Network Configuration**:

```yaml
configure_docker_networks_default_networks:
  - name: "web-network"
    subnet: "172.20.0.0/16"
  - name: "db-network"
    subnet: "172.21.0.0/16"
```

**Firewall Rules**:

```yaml
configure_firewall_web_ports: [80, 443, 8080]
configure_firewall_docker_networks:
  - "172.20.0.0/16"
  - "172.21.0.0/16"
```

**Security Updates**:

```yaml
configure_security_updates_email: "your-email@gmail.com"
configure_security_updates_gmail_enabled: true
```

### How do I configure email notifications?

1. **Generate Gmail App Password**:

   - Enable 2FA on your Gmail account
   - Generate an App Password
   - Use the App Password in configuration

2. **Update configuration**:

   ```yaml
   configure_security_updates_gmail_user: "your-email@gmail.com"
   configure_security_updates_gmail_password: "your-app-password"
   ```

3. **Deploy configuration**:

   ```bash
   ansible-playbook --tags "configure_security_updates" playbooks/full.yml
   ```

### How do I add custom Docker networks?

Edit the appropriate environment file:

**For Production:**

```yaml
# src/inventory/group_vars/production/main.yml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
  - name: "cache-network"
    subnet: "172.24.0.0/16"
    driver: "bridge"
```

### How do I configure monitoring alerts?

```yaml
configure_monitoring_enabled: true
configure_monitoring_alert_email: "admin@example.com"
configure_monitoring_alert_webhook: "https://hooks.slack.com/..."
configure_monitoring_check_interval: 300
```

## Security

### What security features are included?

- **SSH Hardening**: Key-based authentication, password disabled
- **Host Key Verification**: Prevents man-in-the-middle attacks
- **UFW Firewall**: Network security with Docker support
- **Fail2ban**: SSH brute force protection
- **Network Segmentation**: Isolated Docker networks
- **Container Security**: User namespace remapping, privilege restrictions
- **Security Updates**: Automatic security patch installation

### How secure is the default configuration?

The default configuration implements security best practices:

- **Multi-layer security** approach
- **Principle of least privilege**
- **Network isolation** and segmentation
- **Comprehensive monitoring** and alerting
- **Regular security updates**

### How do I verify security is working?

```bash
# Test SSH security
ansible all -m shell -a "sudo sshd -T | grep -E 'password|permitroot'"

# Check firewall status
ansible all -m shell -a "sudo ufw status verbose"

# Test network security
ansible-playbook --tags "test_network_security" playbooks/full.yml

# Check fail2ban status
ansible all -m shell -a "sudo fail2ban-client status sshd"
```

### What if I get locked out of my server?

1. **Use console access** if available
2. **Reset SSH configuration**:

   ```bash
   sudo nano /etc/ssh/sshd_config
   # Change PasswordAuthentication to yes temporarily
   sudo systemctl restart ssh
   ```

3. **Contact hosting provider** for emergency access

### How do I whitelist my IP address?

```bash
# Add IP to UFW whitelist
sudo ufw allow from YOUR_IP_ADDRESS

# Add IP to fail2ban whitelist
sudo nano /etc/fail2ban/jail.local
# Add to ignoreip line
```

## Docker and Networking

### How does Docker network segmentation work?

The project creates three isolated networks:

- **Web Network** (172.20.0.0/16): Frontend services
- **Database Network** (172.21.0.0/16): Databases and backend
- **Monitoring Network** (172.22.0.0/16): Monitoring and logging

**Benefits**:

- **Isolation**: Services on different networks can't communicate directly
- **Security**: Reduced attack surface and network exposure
- **Organization**: Clear separation of concerns
- **Scalability**: Easy to add new networks and services

### How do I deploy applications to specific networks?

```bash
# Deploy to web network
docker run -d --name web-app --network web-network nginx:alpine

# Deploy to database network
docker run -d --name db-app --network db-network postgres:13

# Connect containers across networks (if needed)
docker network connect db-network web-app
```

### How do I test network isolation?

```bash
# Run network security test using tags
ansible-playbook --tags "test_network_security" playbooks/full.yml

# Manual testing
docker run --rm --network web-network alpine ping -c 3 172.21.0.1
```

### What if containers can't communicate?

1. **Check network configuration**:

   ```bash
   docker network ls
   docker network inspect network-name
   ```

2. **Verify firewall rules**:

   ```bash
   sudo ufw status numbered
   ```

3. **Test connectivity**:

   ```bash
   docker exec container-name ping -c 3 target-container
   ```

### How do I add custom Docker networks for testing?

```yaml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
    options:
      com.docker.network.bridge.name: "api-br0"
```

## Troubleshooting

### SSH connection issues

**Common problems and solutions**:

1. **Connection refused**:

   ```bash
   # Check SSH service
   ssh user@server "sudo systemctl status ssh"
   
   # Check firewall
   ssh user@server "sudo ufw status"
   ```

2. **Host key verification failed**:

   ```bash
   # Remove old key
   ssh-keygen -R server-ip
   
   # Add new key
   ssh-keyscan -H server-ip >> ~/.ssh/known_hosts
   ```

3. **Permission denied**:

   ```bash
   # Check SSH key
   ssh-add -l
   
   # Test key
   ssh -i ~/.ssh/your-key user@server
   ```

### Ansible playbook failures

**Debug steps**:

1. **Check connectivity**:

   ```bash
   ansible all -m ping
   ```

2. **Run with verbose output**:

   ```bash
   ansible-playbook -vvv playbooks/full.yml
   ```

3. **Check syntax**:

   ```bash
   ansible-playbook --syntax-check playbooks/full.yml
   ```

4. **Use development overrides**:

   ```bash
   # Override host key checking for development
   ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml
   
   # Or use environment variables
   export ANSIBLE_HOST_KEY_CHECKING=False
   ansible-playbook playbooks/full.yml
   ```

### Docker issues

**Common Docker problems**:

1. **Docker service not running**:

   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

2. **Permission denied**:

   ```bash
   sudo usermod -aG docker $USER
   # Log out and back in
   ```

3. **Network creation failed**:

   ```bash
   # Remove existing networks
   docker network rm network-name
   
   # Recreate networks
   ansible-playbook --tags "configure_docker_networks" playbooks/full.yml
   ```

### Firewall issues

**UFW troubleshooting**:

1. **Check firewall status**:

   ```bash
   sudo ufw status verbose
   ```

2. **Reset firewall**:

   ```bash
   sudo ufw reset
   sudo ufw allow 22/tcp
   sudo ufw enable
   ```

3. **Check logs**:

   ```bash
   sudo tail -f /var/log/ufw.log
   ```

## Development

### How do I use the DevContainer?

1. **Launch the environment**:

   ```bash
   ./launch.sh
   ```

2. **The container provides**:

   - Ansible 9.2.0 with linting
   - Docker CLI tools
   - SSH agent with key management
   - VS Code extensions
   - Custom shell prompt

### How do I test my changes?

1. **Syntax check**:

   ```bash
   ansible-playbook --syntax-check playbooks/full.yml
   ```

2. **Lint check**:

   ```bash
   ansible-lint playbooks/
   ```

3. **Dry run**:

   ```bash
   ansible-playbook --check playbooks/full.yml
   ```

4. **Test deployment**:

   ```bash
   # For development with relaxed security
   ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml
   
   # For production with strict security
   ansible-playbook playbooks/full.yml
   ```

### How do I add a new role?

1. **Create role structure**:

   ```bash
   mkdir -p src/roles/new_role/{tasks,handlers,defaults,vars,meta}
   ```

2. **Create main task file**:

   ```yaml
   # src/roles/new_role/tasks/main.yml
   - name: Task description
     module_name:
       parameter: value
   ```

3. **Add to playbook**:

   ```yaml
   # src/playbooks/full.yml
   roles:
     - new_role
   ```

### How do I customize existing roles?

1. **Override variables**:

   ```yaml
   # In inventory/group_vars/production/main.yml (or staging/development)
   role_name_enabled: true
   role_name_custom_setting: "value"
   ```

2. **Use tags**:

   ```bash
   ansible-playbook playbooks/full.yml --tags "role_name"
   ```

3. **Skip roles**:

   ```bash
   ansible-playbook playbooks/full.yml --skip-tags "role_name"
   ```

## Performance

### How much resources does the deployment require?

**Minimum requirements**:

- **CPU**: 1 vCPU (2+ recommended)
- **Memory**: 1GB RAM (2GB+ recommended)
- **Storage**: 20GB disk space
- **Network**: Stable internet connection

**Development environment**:

- **Memory**: 4GB RAM (8GB recommended)
- **Storage**: 10GB free space
- **Docker**: 2GB+ available

### How long does deployment take?

**Typical deployment times**:

- **Full deployment**: 10-15 minutes
- **Docker installation**: 3-5 minutes
- **Security configuration**: 2-3 minutes
- **Network setup**: 1-2 minutes

**Factors affecting time**:

- Server specifications
- Network speed
- Package download times
- System update requirements

### How do I optimize performance?

1. **Use SSD storage** for faster I/O
2. **Increase memory** for better Docker performance
3. **Use faster network** for package downloads
4. **Optimize Docker daemon** configuration
5. **Monitor resource usage** regularly

### How do I monitor system performance?

```bash
# Check system resources
ansible all -m shell -a "top -bn1 | head -20"
ansible all -m shell -a "df -h"
ansible all -m shell -a "free -h"

# Check Docker performance
ansible all -m shell -a "docker stats --no-stream"

# Monitor system load
ansible all -m shell -a "uptime"
```

## Maintenance

### How do I update the system?

```bash
# Run system updates
ansible-playbook --tags "update_ubuntu" playbooks/full.yml

# Check for required reboots
ansible-playbook --tags "reboot_server" playbooks/full.yml
```

### How do I update Docker?

```bash
# Update Docker packages
ansible-playbook --tags "deploy_docker" playbooks/full.yml

# Or manually
sudo apt-get update
sudo apt-get upgrade docker-ce
```

### How do I backup my configuration?

```bash
# Backup Ansible configuration
tar -czf ansible-config-backup-$(date +%Y%m%d).tar.gz src/

# Backup server configuration
ansible all -m shell -a "sudo tar -czf /tmp/server-config-backup-$(date +%Y%m%d).tar.gz /etc/"
```

### How do I restore from backup?

```bash
# Restore Ansible configuration
tar -xzf ansible-config-backup-YYYYMMDD.tar.gz

# Restore server configuration
sudo tar -xzf server-config-backup-YYYYMMDD.tar.gz -C /
```

### How do I monitor security updates?

```bash
# Check security update status
sudo unattended-upgrade --dry-run

# Check update logs
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log

# Test notification system
sudo /opt/security-updates/security-update-notify.sh 'Test' 'Test notification'
```

## Advanced Topics

### How do I deploy to multiple servers?

1. **Update inventory**:

   ```yaml
   # src/inventory/hosts.yml
   all:
     children:
       web_servers:
         hosts:
           web1:
             ansible_host: "192.168.1.10"
           web2:
             ansible_host: "192.168.1.11"
       db_servers:
         hosts:
           db1:
             ansible_host: "192.168.1.20"
   ```

2. **Deploy to specific groups**:

   ```bash
   ansible-playbook playbooks/full.yml --limit=web_servers
   ```

### How do I implement high availability?

1. **Load balancer configuration**
2. **Database clustering**
3. **Shared storage setup**
4. **Failover procedures**
5. **Monitoring and alerting**

### How do I integrate with CI/CD?

1. **GitHub Actions**:

   ```yaml
   - name: Deploy to server
     run: |
       ansible-playbook -i inventory/hosts.yml playbooks/full.yml
   ```

2. **Jenkins pipeline**:

   ```groovy
   stage('Deploy') {
     steps {
       sh 'ansible-playbook playbooks/full.yml'
     }
   }
   ```

### How do I implement disaster recovery?

1. **Regular backups** of configuration and data
2. **Documented recovery procedures**
3. **Testing of recovery processes**
4. **Monitoring of backup systems**
5. **Off-site backup storage**

### How do I scale the deployment?

1. **Horizontal scaling**: Add more servers
2. **Vertical scaling**: Increase server resources
3. **Load balancing**: Distribute traffic
4. **Database scaling**: Master-slave replication
5. **Storage scaling**: Distributed storage systems

This comprehensive FAQ addresses the most common questions and provides practical solutions for using and maintaining the Ansible infrastructure automation project.
