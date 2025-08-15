# Troubleshooting Guide

## Overview

This troubleshooting guide provides solutions for common issues encountered during deployment and operation of the Ansible-based infrastructure automation project. Each section includes diagnostic steps, common causes, and resolution procedures.

## Quick Diagnostic Commands

### System Health Check

```bash
# Check Ansible connectivity
ansible all -m ping

# Check system status
ansible all -m shell -a "systemctl status"

# Check Docker status
ansible all -m shell -a "sudo systemctl status docker"

# Check firewall status
ansible all -m shell -a "sudo ufw status verbose"

# Check SSH connectivity
ssh -v user@server
```

### Network Security Check

```bash
# Check Docker networks
ansible all -m shell -a "docker network ls"

# Test network isolation
ansible all -m shell -a "sudo ufw status numbered"

# Check container connectivity
ansible all -m shell -a "docker ps -a"
```

## Common Issues and Solutions

### 1. SSH Connection Issues

#### Issue: SSH Connection Refused

**Symptoms**:

- `ssh: connect to host server_ip port 22: Connection refused`
- Ansible playbook fails with connection errors

**Diagnostic Steps**:

```bash
# Check if SSH service is running
ssh user@server "sudo systemctl status ssh"

# Check SSH port
nmap -p 22 server_ip

# Check SSH configuration
ssh user@server "sudo sshd -T | grep -E 'port|listen'"
```

**Common Causes**:

- SSH service not running
- Firewall blocking port 22
- SSH daemon configuration issues
- Network connectivity problems

**Solutions**:

```bash
# Start SSH service
ssh user@server "sudo systemctl start ssh"

# Check firewall rules
ssh user@server "sudo ufw status"

# Allow SSH through firewall
ssh user@server "sudo ufw allow 22/tcp"

# Check SSH configuration
ssh user@server "sudo nano /etc/ssh/sshd_config"
```

#### Issue: SSH Host Key Verification Failed

**Symptoms**:

- `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`
- Ansible fails with host key verification errors

**Diagnostic Steps**:

```bash
# Check known_hosts file
cat ~/.ssh/known_hosts | grep server_ip

# Check server host key
ssh-keyscan -H server_ip
```

**Solutions**:

```bash
# Remove old host key
ssh-keygen -R server_ip

# Add new host key
ssh-keyscan -H server_ip >> ~/.ssh/known_hosts

# Update Ansible known_hosts
ssh-keyscan -H server_ip >> src/inventory/known_hosts
```

#### Issue: SSH Key Authentication Failed

**Symptoms**:

- `Permission denied (publickey)`
- SSH key not accepted

**Diagnostic Steps**:

```bash
# Check SSH key
ssh-add -l

# Test SSH key
ssh -i ~/.ssh/your-key user@server

# Check SSH agent
ssh-add ~/.ssh/your-key
```

**Solutions**:

```bash
# Add key to SSH agent
ssh-add ~/.ssh/your-key

# Copy public key to server
ssh-copy-id -i ~/.ssh/your-key.pub user@server

# Check key permissions
chmod 600 ~/.ssh/your-key
chmod 644 ~/.ssh/your-key.pub
```

### 2. Ansible Execution Issues

#### Issue: Ansible Playbook Fails

**Symptoms**:

- Playbook execution stops with errors
- Tasks fail with permission or connection issues

**Diagnostic Steps**:

```bash
# Check Ansible configuration
ansible --version

# Test inventory
ansible-inventory --list

# Check playbook syntax
ansible-playbook --syntax-check playbooks/full.yml

# Run with verbose output
ansible-playbook -vvv playbooks/full.yml
```

**Common Solutions**:

```bash
# Use development overrides for testing
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbooks/full.yml

# Check inventory variables
cat inventory/group_vars/production/main.yml

# Test connectivity
ansible all -m ping
```

#### Issue: Ansible Permission Denied

**Symptoms**:

- `Permission denied` errors during playbook execution
- Sudo password prompts

**Solutions**:

```bash
# Check sudo configuration
ssh user@server "sudo -l"

# Add user to sudoers
ssh user@server "sudo usermod -aG sudo user"

# Configure passwordless sudo
ssh user@server "echo 'user ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user"
```

#### Issue: Ansible Variable Errors

**Symptoms**:

- `Variable not defined` errors
- Missing variable values

**Diagnostic Steps**:

```bash
# Check variable definitions
ansible-inventory --list -y

# Check group variables
cat inventory/group_vars/production/main.yml

# Validate variable syntax
ansible-playbook --check playbooks/full.yml
```

**Solutions**:

```bash
# Copy and customize the appropriate environment file
cp inventory/group_vars/production/main.yml inventory/group_vars/production/main.yml.backup

# Edit variables
nano inventory/group_vars/production/main.yml

# Test with specific variables
ansible-playbook playbooks/full.yml -e "variable_name=value"
```

### 3. Docker Issues

#### Issue: Docker Service Not Running

**Symptoms**:

- `Cannot connect to the Docker daemon`
- Docker commands fail

**Diagnostic Steps**:

```bash
# Check Docker service
ansible all -m shell -a "sudo systemctl status docker"

# Check Docker daemon logs
ansible all -m shell -a "sudo journalctl -u docker -f"

# Check Docker socket
ansible all -m shell -a "ls -la /var/run/docker.sock"
```

**Solutions**:

```bash
# Start Docker service
ansible all -m shell -a "sudo systemctl start docker"

# Enable Docker service
ansible all -m shell -a "sudo systemctl enable docker"

# Add user to docker group
ansible all -m shell -a "sudo usermod -aG docker $USER"

# Restart Docker daemon
ansible all -m shell -a "sudo systemctl restart docker"
```

#### Issue: Docker Network Creation Failed

**Symptoms**:

- `Error response from daemon: network with name already exists`
- Docker networks not created

**Diagnostic Steps**:

```bash
# List existing networks
ansible all -m shell -a "docker network ls"

# Check network configuration
ansible all -m shell -a "docker network inspect web-network"
```

**Solutions**:

```bash
# Remove existing networks
ansible all -m shell -a "docker network rm web-network db-network monitoring-network"

# Recreate networks
ansible-playbook --tags "configure_docker_networks" playbooks/full.yml

# Check network isolation
ansible-playbook --tags "test_network_security" playbooks/full.yml
```

#### Issue: Container Communication Issues

**Symptoms**:

- Containers cannot communicate
- Network isolation too restrictive

**Diagnostic Steps**:

```bash
# Test container connectivity
ansible all -m shell -a "docker run --rm --network web-network alpine ping -c 3 8.8.8.8"

# Check network policies
ansible all -m shell -a "sudo ufw status numbered"

# Test inter-network communication
ansible all -m shell -a "docker run --rm --network web-network alpine ping -c 3 db-network"
```

**Solutions**:

```bash
# Allow inter-network communication
ansible all -m shell -a "sudo ufw allow from 172.20.0.0/16 to 172.21.0.0/16"

# Check Docker daemon configuration
ansible all -m shell -a "sudo cat /etc/docker/daemon.json"

# Restart Docker with new configuration
ansible all -m shell -a "sudo systemctl restart docker"
```

### 4. Firewall Issues

#### Issue: UFW Firewall Blocking Connections

**Symptoms**:

- Services not accessible
- Connection timeouts
- Firewall blocking legitimate traffic

**Diagnostic Steps**:

```bash
# Check firewall status
ansible all -m shell -a "sudo ufw status verbose"

# Check firewall logs
ansible all -m shell -a "sudo tail -f /var/log/ufw.log"

# Test port accessibility
ansible all -m shell -a "sudo netstat -tlnp"
```

**Solutions**:

```bash
# Allow specific ports
ansible all -m shell -a "sudo ufw allow 80/tcp"
ansible all -m shell -a "sudo ufw allow 443/tcp"

# Allow Docker networks
ansible all -m shell -a "sudo ufw allow from 172.20.0.0/16"

# Check firewall rules
ansible all -m shell -a "sudo ufw status numbered"

# Reset firewall if needed
ansible all -m shell -a "sudo ufw reset"
```

#### Issue: Firewall Configuration Errors

**Symptoms**:

- UFW not starting
- Firewall rules not applied
- Configuration syntax errors

**Diagnostic Steps**:

```bash
# Check UFW service
ansible all -m shell -a "sudo systemctl status ufw"

# Check UFW configuration
ansible all -m shell -a "sudo cat /etc/ufw/ufw.conf"

# Test UFW rules
ansible all -m shell -a "sudo ufw --dry-run"
```

**Solutions**:

```bash
# Reinstall UFW
ansible all -m shell -a "sudo apt-get install --reinstall ufw"

# Reset UFW configuration
ansible all -m shell -a "sudo ufw reset"

# Reconfigure firewall
ansible-playbook --tags "configure_firewall" playbooks/full.yml
```

### 5. Security Issues

#### Issue: Fail2ban Blocking Legitimate Access

**Symptoms**:

- SSH access blocked
- IP addresses banned
- False positive detections

**Diagnostic Steps**:

```bash
# Check fail2ban status
ansible all -m shell -a "sudo systemctl status fail2ban"

# Check banned IPs
ansible all -m shell -a "sudo fail2ban-client status sshd"

# Check fail2ban logs
ansible all -m shell -a "sudo tail -f /var/log/fail2ban.log"
```

**Solutions**:

```bash
# Unban IP address
ansible all -m shell -a "sudo fail2ban-client set sshd unbanip YOUR_IP"

# Add IP to whitelist
ansible all -m shell -a "sudo ufw allow from YOUR_IP"

# Restart fail2ban
ansible all -m shell -a "sudo systemctl Restart fail2ban"

# Adjust fail2ban configuration
ansible all -m shell -a "sudo nano /etc/fail2ban/jail.local"
```

#### Issue: SSH Security Too Restrictive

**Symptoms**:

- SSH access denied
- Key authentication failing
- Password authentication disabled

**Diagnostic Steps**:

```bash
# Check SSH configuration
ansible all -m shell -a "sudo sshd -T | grep -E 'password|permitroot|pubkey'"

# Check SSH service
ansible all -m shell -a "sudo systemctl status ssh"

# Test SSH connection
ssh -v user@server
```

**Solutions**:

```bash
# Temporarily enable password authentication
ansible all -m shell -a "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config"

# Restart SSH service
ansible all -m shell -a "sudo systemctl restart ssh"

# Check SSH keys
ansible all -m shell -a "ls -la ~/.ssh/"

# Reconfigure SSH security
ansible-playbook --tags "disable_password_authentication" playbooks/full.yml
```

### 6. Monitoring Issues

#### Issue: Security Update Notifications Not Working

**Symptoms**:

- No email notifications
- Security updates not running
- Gmail SMTP errors

**Diagnostic Steps**:

```bash
# Check unattended-upgrades
ansible all -m shell -a "sudo unattended-upgrade --dry-run"

# Check email configuration
ansible all -m shell -a "sudo cat /etc/aliases"

# Test email sending
ansible all -m shell -a "echo 'Test email' | mail -s 'Test' your-email@gmail.com"
```

**Solutions**:

```bash
# Reconfigure security updates
ansible-playbook --tags "configure_security_updates" playbooks/full.yml

# Check Gmail app password
# Ensure 2FA is enabled and app password is generated

# Test notification script
ansible all -m shell -a "sudo /opt/security-updates/security-update-notify.sh 'Test' 'Test notification'"
```

#### Issue: System Monitoring Not Working

**Symptoms**:

- No monitoring data
- Health checks failing
- Alert system not working

**Diagnostic Steps**:

```bash
# Check monitoring services
ansible all -m shell -a "sudo systemctl status monitoring"

# Check monitoring logs
ansible all -m shell -a "sudo journalctl -u monitoring -f"

# Check system resources
ansible all -m shell -a "df -h && free -h && uptime"
```

**Solutions**:

```bash
# Reconfigure monitoring
ansible-playbook --tags "configure_monitoring" playbooks/full.yml

# Check monitoring configuration
ansible all -m shell -a "sudo cat /etc/monitoring/config.yml"

# Restart monitoring services
ansible all -m shell -a "sudo systemctl restart monitoring"
```

### 7. Development Environment Issues

#### Issue: DevContainer Not Starting

**Symptoms**:

- VS Code DevContainer fails to build
- Container startup errors
- Environment variables not loaded

**Diagnostic Steps**:

```bash
# Check Docker service
docker --version
docker ps

# Check environment variables
cat .devcontainer/config/.env

# Check DevContainer configuration
cat .devcontainer/devcontainer.json
```

**Solutions**:

```bash
# Rebuild DevContainer
docker-compose down
docker-compose build --no-cache

# Check Docker resources
docker system df

# Clean up Docker
docker system prune -a

# Restart VS Code
code --remote-containers rebuild
```

#### Issue: Ansible Tools Not Available

**Symptoms**:

- Ansible command not found
- Ansible-lint not working
- Python interpreter issues

**Diagnostic Steps**:

```bash
# Check Ansible installation
ansible --version

# Check Python interpreter
which python3

# Check Ansible configuration
cat src/ansible.cfg
```

**Solutions**:

```bash
# Reinstall Ansible
pip install --upgrade ansible

# Install Ansible lint
pip install ansible-lint

# Check Ansible path
echo $PATH

# Rebuild DevContainer
docker-compose build --no-cache
```

## Advanced Troubleshooting

### 1. Network Security Testing

#### Manual Network Security Test

```bash
# Create test containers
docker run -d --name test-web --network web-network nginx:alpine
docker run -d --name test-db --network db-network postgres:13

# Test network isolation
docker exec test-web ping -c 3 test-db
docker exec test-db ping -c 3 test-web

# Test firewall rules
sudo ufw status numbered
sudo iptables -L -n -v
```

#### Network Connectivity Test

```bash
# Test external connectivity
docker run --rm alpine ping -c 3 8.8.8.8

# Test internal connectivity
docker run --rm --network web-network alpine ping -c 3 172.20.0.1

# Test port accessibility
docker run --rm alpine nc -zv google.com 80
```

### 2. System Performance Analysis

#### Resource Usage Check

```bash
# Check system resources
ansible all -m shell -a "top -bn1 | head -20"
ansible all -m shell -a "df -h"
ansible all -m shell -a "free -h"

# Check Docker resource usage
ansible all -m shell -a "docker stats --no-stream"

# Check system load
ansible all -m shell -a "uptime"
```

#### Performance Optimization

```bash
# Clean up Docker
ansible all -m shell -a "docker system prune -f"

# Check log sizes
ansible all -m shell -a "du -sh /var/log/*"

# Optimize system
ansible all -m shell -a "sudo apt-get autoremove -y"
```

### 3. Log Analysis

#### System Log Analysis

```bash
# Check system logs
ansible all -m shell -a "sudo journalctl -f"

# Check SSH logs
ansible all -m shell -a "sudo tail -f /var/log/auth.log"

# Check Docker logs
ansible all -m shell -a "sudo journalctl -u docker -f"

# Check firewall logs
ansible all -m shell -a "sudo tail -f /var/log/ufw.log"
```

#### Ansible Log Analysis

```bash
# Enable Ansible logging
export ANSIBLE_LOG_PATH=/tmp/ansible.log
ansible-playbook -vvv playbooks/full.yml

# Check Ansible logs
tail -f /tmp/ansible.log

# Analyze playbook execution
ansible-playbook --check playbooks/full.yml
```

## Emergency Procedures

### 1. Server Access Recovery

#### If SSH Access is Lost

```bash
# Use console access if available
# Reset SSH configuration
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh

# If console access not available, contact hosting provider
```

#### If Root Access is Lost

```bash
# Boot into recovery mode
# Mount filesystem in read-write mode
mount -o remount,rw /

# Reset user passwords
passwd username

# Restart SSH service
systemctl restart ssh
```

### 2. Service Recovery

#### Docker Service Recovery

```bash
# Stop all containers
docker stop $(docker ps -q)

# Restart Docker daemon
sudo systemctl restart docker

# Check Docker daemon logs
sudo journalctl -u docker -f
```

#### Firewall Recovery

```bash
# Reset firewall to default
sudo ufw reset

# Allow SSH access
sudo ufw allow 22/tcp

# Enable firewall
sudo ufw enable
```

### 3. Data Recovery

#### Configuration Backup

```bash
# Restore from backup
tar -xzf backup-$(date +%Y%m%d).tar.gz

# Restore Ansible configuration
cp -r backup/src/ ./

# Restore server configuration
sudo tar -xzf server-config-backup.tar.gz -C /
```

#### Application Data Recovery

```bash
# Restore Docker volumes
docker run --rm -v volume_name:/data -v $(pwd):/backup alpine tar xzf /backup/volume-backup.tar.gz -C /data

# Restore application data
scp -r backup/apps/ user@server:/opt/
```

## Prevention and Best Practices

### 1. Regular Maintenance

- Schedule regular system updates
- Monitor system resources
- Review security logs
- Test backup and recovery procedures

### 2. Monitoring Setup

- Configure comprehensive monitoring
- Set up alert systems
- Monitor security events
- Track system performance

### 3. Documentation

- Document all customizations
- Maintain runbooks for common procedures
- Update troubleshooting guides
- Keep configuration backups

This comprehensive troubleshooting guide provides solutions for the most common issues encountered during deployment and operation of the Ansible infrastructure automation project.
