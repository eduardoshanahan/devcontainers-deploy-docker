# Configure Container Security Role

This role implements container security scanning and monitoring to detect vulnerabilities and security issues in Docker containers.

## What it does

- Installs container security scanning tools (Trivy, Clair)
- Configures automated vulnerability scanning
- Implements container behavior monitoring
- Sets up security alerts and notifications
- Configures Docker content trust
- Creates security audit trails
- **NEW**: Auto-cleanup of vulnerable Docker images
- **NEW**: Dedicated cleanup playbook integration

## Security Features

### Vulnerability Scanning

- **Automated scanning**: Daily scans of all running containers
- **Multiple tools**: Trivy and Clair integration
- **Severity filtering**: Focus on HIGH and CRITICAL vulnerabilities
- **Report generation**: JSON reports with timestamps
- **Auto-cleanup**: Automatic removal of vulnerable images

### Container Monitoring

- **Privileged containers**: Detect containers running with elevated privileges
- **Host network**: Monitor containers using host networking
- **Host mounts**: Detect containers with host volume mounts
- **Unusual behavior**: Monitor for suspicious container activity
- **Vulnerable images**: Automatic detection and cleanup

### Security Alerts

- **Email notifications**: Alert on security issues
- **Logging**: Comprehensive security event logging
- **Audit trail**: Complete record of security events
- **Auto-cleanup logs**: Detailed cleanup activity logging

## Configuration

### Role Behavior Settings (Role Defaults)

```yaml
# In role defaults/main.yml
configure_container_security_enabled: true
configure_container_security_enable_content_trust: true
configure_container_security_scan_schedule: "daily"
configure_container_security_auto_cleanup: false  # NEW
```

### Environment-Specific Settings (Inventory Variables)

```yaml
# In inventory/group_vars/all.yml
configure_container_security_alert_email: "your-email@example.com"
configure_container_security_scan_severity: "HIGH,CRITICAL"
configure_container_security_auto_cleanup: true  # NEW
```

## Usage

### Standard Deployment

```bash
# Deploy container security
ansible-playbook playbooks/configure_container_security.yml
```

### Manual Scanning

```bash
# Run manual container scan
sudo /opt/security/container-scan.sh

# Check scan results
ls -la /opt/security/scans/

# Run manual cleanup
sudo /opt/security/cleanup-vulnerable-images.sh
```

### Docker Cleanup

```bash
# Dedicated cleanup playbook
ansible-playbook playbooks/cleanup_docker_images.yml

# Clean slate deployment
ansible-playbook playbooks/deploy_docker.yml -e "deploy_docker_clean_slate=true"
```

## Security Benefits

1. **Vulnerability Detection**: Automated discovery of security issues
2. **Compliance**: Meets container security requirements
3. **Monitoring**: Continuous security oversight
4. **Alerting**: Immediate notification of security issues
5. **Audit Trail**: Complete security event history
6. **Auto-Cleanup**: Automatic removal of vulnerable images
7. **Reduced Attack Surface**: Eliminates known vulnerable containers

## Troubleshooting

### Scan Failures

- Check if Trivy is installed: `which trivy`
- Verify Docker is running: `docker ps`
- Check scan logs: `tail -f /var/log/container-security.log`

### Monitoring Issues

- Verify monitoring script: `/opt/security/container-monitor.sh`
- Check cron jobs: `crontab -l`
- Review security logs: `tail -f /var/log/container-security.log`
