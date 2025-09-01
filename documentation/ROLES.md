# Ansible Roles Documentation

## Overview

This project uses a modular Ansible role architecture to organize and maintain server configuration tasks. Each role implements a specific server function and can be used independently or as part of the complete deployment process.

## Role Architecture

### Role Organization

```mermaid
graph TB
    subgraph "System Management"
        A[update_ubuntu]
        B[configure_security_updates]
        C[create_deployment_user]
    end
    
    subgraph "Security"
        D[disable_password_authentication]
        E[configure_firewall]
        F[configure_fail2ban]
        G[configure_container_security]
    end
    
    subgraph "Docker & Networking"
        H[deploy_docker]
        I[configure_docker_networks]
        J[test_network_security]
    end
    
    subgraph "Monitoring & Maintenance"
        K[configure_monitoring]
        L[configure_log_rotation]
        M[configure_remote_logging]
        N[configure_log_download]
        O[configure_reporting]
    end
    
    A --> D
    B --> E
    C --> F
    D --> G
    E --> H
    F --> I
    G --> J
    H --> K
    I --> L
    J --> M
    K --> N
    L --> O
```

## Role Details

### 1. System Management Roles

#### update_ubuntu

**Purpose**: Performs system updates and security patches on Ubuntu servers.

**Tasks**:

- Update package lists
- Upgrade installed packages
- Install security updates
- Clean up package cache
- Reboot if required

**Variables**:

```yaml
update_ubuntu_reboot_required: false
update_ubuntu_automatic_reboot: false
update_ubuntu_reboot_timeout: 300
```

**Usage**:

```bash
# Run system updates using tags
ansible-playbook --tags "update_ubuntu" playbooks/full.yml

# With custom variables
ansible-playbook --tags "update_ubuntu" playbooks/full.yml -e "update_ubuntu_automatic_reboot=true"
```

**Dependencies**: None

**Output**: Updated system packages and security patches

---

#### configure_security_updates

**Purpose**: Configures automatic security updates and email notifications.

**Tasks**:

- Install unattended-upgrades package
- Configure automatic security updates
- Set up email notifications
- Configure update schedules
- Test notification system

**Variables**:

```yaml
configure_security_updates_enabled: true
configure_security_updates_email: "admin@example.com"
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-email@gmail.com"
configure_security_updates_gmail_password: "your-app-password"
configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
configure_security_updates_gmail_smtp_port: "465"
configure_security_updates_auto_reboot: false
configure_security_updates_auto_reboot_time: "02:00"
```

**Usage**:

```bash
# Configure security updates using tags
ansible-playbook --tags "configure_security_updates" playbooks/full.yml
```

**Dependencies**: update_ubuntu

**Output**: Automatic security updates with email notifications

---

#### create_deployment_user

**Purpose**: Creates a dedicated deployment user with proper permissions.

**Tasks**:

- Create deployment user account
- Set up SSH key authentication
- Configure sudo privileges
- Set up user environment
- Configure SSH access

**Variables**:

```yaml
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/deployment-key"
containers_deployment_user_ssh_key_public: "/path/to/public/key.pub"
containers_deployment_user_sudo_nopasswd: true
```

**Usage**:

```bash
# Create deployment user using tags
ansible-playbook --tags "create_deployment_user" playbooks/full.yml
```

**Dependencies**: None

**Output**: Dedicated deployment user with SSH and sudo access

---

### 2. Security Roles

#### disable_password_authentication

**Purpose**: Hardens SSH security by disabling password authentication.

**Tasks**:

- Disable password authentication
- Disable root login
- Configure SSH security settings
- Validate SSH configuration

**Variables**:

```yaml
disable_password_authentication_ssh_port: "22"
disable_password_authentication_permit_root_login: false
disable_password_authentication_password_authentication: false
disable_password_authentication_pubkey_authentication: true
```

**Usage**:

```bash
# Configure SSH security using tags
ansible-playbook --tags "disable_password_authentication" playbooks/full.yml
```

**Dependencies**: create_deployment_user

**Output**: Secure SSH configuration with key-based authentication only

---

#### configure_firewall

**Purpose**: Configures UFW firewall with secure rules and Docker network access.

**Tasks**:

- Install and configure UFW
- Set default policies
- Configure SSH access
- Set up Docker network rules
- Configure web service ports
- Enable logging

**Variables**:

```yaml
configure_firewall_enabled: true
configure_firewall_default_policy: "DROP"
configure_firewall_allowed_ports:
  - 22   # SSH
  - 80   # HTTP
  - 443  # HTTPS
configure_firewall_docker_networks:
  - "172.20.0.0/16"  # web-network
  - "172.21.0.0/16"  # db-network
  - "172.22.0.0/16"  # monitoring-network
configure_firewall_logging_level: "medium"
```

**Usage**:

```bash
# Configure firewall using tags
ansible-playbook --tags "configure_firewall" playbooks/full.yml
```

**Dependencies**: None

**Output**: Secure firewall configuration with Docker network access

---

#### configure_fail2ban

**Purpose**: Sets up intrusion prevention and protection against brute force attacks.

**Tasks**:

- Install fail2ban package
- Configure SSH protection
- Set up jail rules
- Configure logging
- Start fail2ban service

**Variables**:

```yaml
configure_fail2ban_enabled: true
configure_fail2ban_max_retry: 3
configure_fail2ban_bantime: 3600
configure_fail2ban_findtime: 600
```

**Usage**:

```bash
# Configure fail2ban using tags
ansible-playbook --tags "configure_fail2ban" playbooks/full.yml
```

**Dependencies**: configure_firewall

**Output**: Active intrusion prevention system

---

#### configure_container_security

**Purpose**: Implements comprehensive container security with vulnerability scanning.

**Tasks**:

- Install Trivy vulnerability scanner
- Configure container security scanning
- Set up security alerts
- Configure automated scanning schedules
- Set up HTML vulnerability reports

**Variables**:

```yaml
configure_container_security_enabled: true
configure_container_security_trivy_enabled: true
configure_container_security_alerts_enabled: true
configure_container_security_alert_email: "security@example.com"
configure_container_security_scan_images: true
configure_container_security_scan_running: true
configure_container_security_scan_schedule: "0 2 * * *"
configure_container_security_severity_threshold: "HIGH"
configure_container_security_ignore_unfixed: true
configure_container_security_auto_cleanup: true
```

**Usage**:

```bash
# Configure container security using tags
ansible-playbook --tags "configure_container_security" playbooks/full.yml
```

**Dependencies**: deploy_docker

**Output**: Container vulnerability scanning and security monitoring

---

### 3. Docker & Networking Roles

#### deploy_docker

**Purpose**: Installs and configures Docker with secure defaults.

**Tasks**:

- Install Docker packages
- Configure Docker daemon
- Set up Docker user permissions
- Configure Docker logging
- Start Docker service

**Variables**:

```yaml
deploy_docker_clean_slate: true
deploy_docker_network_policies: {}
docker_user_enhanced_permissions: true
docker_user_network_management: true
docker_user_system_monitoring: true
```

**Usage**:

```bash
# Deploy Docker using tags
ansible-playbook --tags "deploy_docker" playbooks/full.yml
```

**Dependencies**: None

**Output**: Docker installation with secure configuration

---

#### configure_docker_networks

**Purpose**: Creates secure Docker networks with network segmentation.

**Tasks**:

- Create default networks (web, db, monitoring)
- Configure network isolation
- Set up network labels
- Configure network policies
- Test network connectivity

**Variables**:

```yaml
configure_docker_networks_default_base: "172.20.0.0/16"
configure_docker_networks_default_size: 24
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
configure_docker_networks_custom_networks: []
configure_docker_networks_remove_all: true
```

**Usage**:

```bash
# Configure Docker networks using tags
ansible-playbook --tags "configure_docker_networks" playbooks/full.yml
```

**Dependencies**: deploy_docker

**Output**: Secure Docker networks with network segmentation

---

#### test_network_security

**Purpose**: Validates network security configuration and isolation.

**Tasks**:

- Test network connectivity
- Validate firewall rules
- Test Docker network isolation
- Generate security report
- Clean up test containers

**Variables**:

```yaml
test_network_security_enabled: true
test_network_security_test_mode: true
test_network_security_cleanup: true
```

**Usage**:

```bash
# Test network security using tags
ansible-playbook --tags "test_network_security" playbooks/full.yml
```

**Dependencies**: configure_firewall, configure_docker_networks

**Output**: Network security validation report

---

### 4. Monitoring & Maintenance Roles

#### configure_monitoring

**Purpose**: Sets up lightweight system monitoring and health checks.

**Tasks**:

- Install monitoring tools
- Configure health check scripts
- Set up resource monitoring
- Configure alerting system
- Start monitoring services

**Variables**:

```yaml
configure_monitoring_enabled: true
configure_monitoring_prometheus_enabled: false
configure_monitoring_alert_email: "alerts@example.com"
configure_monitoring_alert_webhook: ""
configure_monitoring_retention_days: 30
configure_monitoring_disk_threshold: 80
configure_monitoring_memory_threshold: 85
configure_monitoring_cpu_threshold: 90
```

**Usage**:

```bash
# Configure monitoring using tags
ansible-playbook --tags "configure_monitoring" playbooks/full.yml
```

**Dependencies**: deploy_docker

**Output**: Active system monitoring with health checks

---

#### configure_log_rotation

**Purpose**: Configures automated log rotation and management.

**Tasks**:

- Configure logrotate for system logs
- Set up Docker log rotation
- Configure log retention policies
- Set up log compression
- Configure log monitoring

**Variables**:

```yaml
configure_log_rotation_enabled: true
configure_log_rotation_max_size: "100M"
configure_log_rotation_rotate_count: 4
configure_log_rotation_compress: true
configure_log_rotation_delay_compress: false
```

**Usage**:

```bash
# Configure log rotation using tags
ansible-playbook --tags "configure_log_rotation" playbooks/full.yml
```

**Dependencies**: deploy_docker

**Output**: Automated log management with retention policies

---

#### configure_remote_logging

**Purpose**: Sets up secure remote logging and log analysis.

**Tasks**:

- Configure rsyslog for remote logging
- Set up log encryption
- Configure log forwarding
- Set up log analysis tools
- Configure log retention

**Variables**:

```yaml
configure_remote_logging_enabled: true
configure_remote_logging_server: "log-server.example.com"
configure_remote_logging_protocol: "udp"
configure_remote_logging_port: 514
configure_remote_logging_retry_interval: 30
configure_remote_logging_max_retries: 3
configure_remote_logging_forward_all_logs: true
configure_remote_logging_forward_security_logs: true
configure_remote_logging_forward_system_logs: true
configure_remote_logging_forward_docker_logs: true
```

**Usage**:

```bash
# Configure remote logging using tags
ansible-playbook --tags "configure_remote_logging" playbooks/full.yml
```

**Dependencies**: configure_log_rotation

**Output**: Centralized logging configuration

---

#### configure_log_download

**Purpose**: Sets up secure log collection and analysis capabilities.

**Tasks**:

- Install log collection tools
- Configure secure log download
- Set up log encryption
- Configure automated log collection
- Set up log cleanup procedures

**Variables**:

```yaml
configure_log_download_enabled: true
configure_log_download_auto_collect: true
configure_log_download_auto_cleanup: true
configure_log_download_retention_days: 7
configure_log_download_secure_only: true
configure_log_download_encrypt_exports: true
configure_log_download_cleanup_passwords: true
configure_log_download_require_auth: true
configure_log_download_allowed_ips: []
```

**Usage**:

```bash
# Configure log download using tags
ansible-playbook --tags "configure_log_download" playbooks/full.yml
```

**Dependencies**: configure_log_rotation

**Output**: Secure log collection and analysis system

---

#### configure_reporting

**Purpose**: Sets up comprehensive system reporting with automated email delivery.

**Tasks**:

- Install reporting dependencies (jq, curl, bc, mailutils)
- Create reporting directory structure
- Configure automated report generation scripts
- Set up cron jobs for scheduled reports
- Configure email delivery using Gmail SMTP
- Implement report cleanup and retention policies

**Variables**:

```yaml
configure_reporting_enabled: true
configure_reporting_email: "reports@example.com"
configure_reporting_gmail_enabled: true
configure_reporting_gmail_user: "your-email@gmail.com"
configure_reporting_gmail_password: "your-app-password"
configure_reporting_gmail_smtp_server: "smtp.gmail.com"
configure_reporting_gmail_smtp_port: "465"
```

**Usage**:

```bash
# Configure reporting using tags
ansible-playbook --tags "configure_reporting" playbooks/full.yml
```

**Dependencies**: configure_security_updates (for email configuration)

**Output**: Automated system reporting with email delivery

**Features**:

- **Daily Reports**: System health, security events, and resource usage (6:00 AM)
- **Weekly Reports**: Extended analysis with trends and statistics (Sunday 7:00 AM)
- **Monthly Reports**: Comprehensive system analysis with long-term trends (1st of month 8:00 AM)
- **HTML Reports**: Beautiful, formatted HTML reports
- **Email Delivery**: Secure email delivery via Gmail SMTP
- **Configurable Schedules**: All report schedules can be customized

---

## Role Execution Order

### Recommended Execution Sequence

**Note**: Individual role execution is now handled through tags on the main playbook. The following shows the logical order of role execution:

1. **System Preparation**
   - `update_ubuntu` - System updates and security patches
   - `create_deployment_user` - Create deployment user

2. **Security Configuration**
   - `disable_password_authentication` - SSH security hardening
   - `configure_firewall` - UFW firewall configuration
   - `configure_fail2ban` - Intrusion prevention

3. **Docker Deployment**
   - `deploy_docker` - Docker installation and configuration
   - `configure_docker_networks` - Network segmentation
   - `configure_container_security` - Security scanning

4. **Monitoring & Maintenance**
   - `configure_monitoring` - System monitoring setup
   - `configure_log_rotation` - Log management
   - `configure_remote_logging` - Centralized logging
   - `configure_log_download` - Secure log collection
   - `configure_reporting` - Automated reporting system

5. **Security Updates**
   - `configure_security_updates` - Automatic security updates

6. **Validation**
   - `test_network_security` - Security validation

### Complete Deployment

```bash
# Run all roles in correct order
ansible-playbook playbooks/full.yml
```

### Individual Role Execution

```bash
# Execute specific roles using tags
ansible-playbook --tags "update_ubuntu,configure_firewall" playbooks/full.yml

# Skip specific roles
ansible-playbook --skip-tags "configure_monitoring" playbooks/full.yml

# Execute roles in sequence
ansible-playbook --tags "update_ubuntu" playbooks/full.yml
ansible-playbook --tags "configure_firewall" playbooks/full.yml
ansible-playbook --tags "deploy_docker" playbooks/full.yml
```

## Role Customization

### 1. Variable Override

```bash
# Override role variables using tags
ansible-playbook --tags "configure_firewall" playbooks/full.yml -e "configure_firewall_ssh_port=2222"
```

### 2. Custom Role Configuration

```yaml
# In src/inventory/group_vars/all/main.yml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
    options:
      com.docker.network.bridge.name: "api-br0"
```

### 3. Role Dependencies

```yaml
# In role meta/main.yml
dependencies:
  - role: update_ubuntu
  - role: configure_firewall
```

## Role Testing

### 1. Syntax Check

```bash
# Check role syntax
ansible-playbook --syntax-check playbooks/full.yml
```

### 2. Dry Run

```bash
# Test role execution without changes
ansible-playbook --check playbooks/full.yml

# Test specific roles
ansible-playbook --check --tags "configure_firewall" playbooks/full.yml
```

### 3. Verbose Execution

```bash
# Verbose output for debugging
ansible-playbook -vvv playbooks/full.yml

# Verbose output for specific roles
ansible-playbook -vvv --tags "deploy_docker" playbooks/full.yml
```

### 4. Role-Specific Testing

```bash
# Test individual roles with dry run
ansible-playbook --check --tags "update_ubuntu" playbooks/full.yml
ansible-playbook --check --tags "configure_firewall" playbooks/full.yml
ansible-playbook --check --tags "deploy_docker" playbooks/full.yml
```

## Role Development

### 1. Creating New Roles

```bash
# Create role structure
mkdir -p src/roles/new_role/{tasks,handlers,defaults,vars,meta,templates}

# Create main task file
touch src/roles/new_role/tasks/main.yml
```

### 2. Role Integration

```yaml
# Add to playbooks/full.yml
roles:
  - new_role
```

### 3. Role Testing

```bash
# Test new role
ansible-playbook --check --tags "new_role" playbooks/full.yml

# Test with full deployment
ansible-playbook --tags "new_role" playbooks/full.yml
```

This documentation now reflects the current project structure where all roles are executed through the main `playbooks/full.yml` playbook using tags, and includes the new roles for reporting, log management, and container security.
