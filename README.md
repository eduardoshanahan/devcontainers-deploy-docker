# Docker Installation in a remote Ubuntu VPS with Ansible & Devcontainers

## Why I have this project

I needed a way to fire up a fresh VPS with Ubuntu, update it and deploy Docker to later run services in containers. I also wanted to be able to update an existing server. And I want to be able to work inside a devcontainer. And I like Ansible a lot more than I like Bash.

## Purpose

- **Automate server preparation:** Update Ubuntu and install Docker on remote servers using Ansible playbooks.
- **Enable containerized deployments:** Set up servers to be ready for containerized applications, reducing manual configuration and potential errors.
- **Leverage Devcontainers:** Use Visual Studio Code Devcontainers for a consistent development and automation environment.
- **Secure deployments:** Implement host key verification and secure SSH configurations for production deployments.
- **Network security:** Configure secure Docker networks with specific IP ranges and network segmentation.

## Key Features

- **Ansible Playbooks:** Automate the update and configuration of Ubuntu servers, including Docker installation and essential system settings.
- **Devcontainer Integration:** Provides a ready-to-use development environment with all necessary tools and configurations for working with Ansible and Docker.
- **Modular Roles:** Organized Ansible roles for tasks such as Docker installation, firewall configuration, monitoring, and more.
- **Inventory Management:** Inventory structure for managing multiple remote servers.
- **Security Features:** Built-in security configurations including SSH hardening, firewall setup, fail2ban protection, and host key verification.
- **Network Security:** Secure Docker network configuration with specific IP ranges and network segmentation.
- **Monitoring & Maintenance:** Automated monitoring, log rotation, and system health checks.
- **Environment-specific Configurations:** Separate configurations for development and production environments.

## Security Configuration

This project implements secure Ansible configurations with host key verification and network security:

- **Secure by default:** `ansible.cfg` uses strict host key checking
- **Development mode:** `ansible.dev.cfg` for testing with relaxed security
- **Host key management:** `inventory/known_hosts` for verified server fingerprints
- **Network security:** Specific Docker networks with defined IP ranges instead of broad network access
- **Documentation:** See `src/SECURITY.md` for detailed security setup and troubleshooting

### Configuration Files

- `ansible.cfg` - Default secure configuration (production-ready)
- `ansible.dev.cfg` - Development configuration (less strict for testing)
- `inventory/known_hosts` - Managed host key verification file

## Project Structure

```text
workspace/
├── .devcontainer/           # Devcontainer configuration for VS Code
│   ├── Dockerfile
│   ├── devcontainer.json
│   ├── .env.example
│   └── settings.json
├── launch_vscode.sh         # Script to launch VS Code with the Dev Container
├── src/
│   ├── inventory/           # Ansible inventory and group variables
│   │   ├── hosts.yml        # Host definitions
│   │   ├── known_hosts      # Host key verification file
│   │   └── group_vars/      # Global variables
│   ├── playbooks/           # Ansible playbooks
│   │   ├── full.yml         # Complete system deployment
│   │   ├── update_ubuntu.yml
│   │   ├── deploy_docker.yml
│   │   ├── configure_firewall.yml
│   │   ├── configure_docker_networks.yml
│   │   ├── configure_fail2ban.yml
│   │   ├── configure_monitoring.yml
│   │   └── configure_log_rotation.yml
│   ├── roles/               # Ansible roles
│   │   ├── update_ubuntu/
│   │   ├── deploy_docker/
│   │   ├── create_deployment_user/
│   │   ├── disable_password_authentication/
│   │   ├── configure_firewall/
│   │   ├── configure_docker_networks/
│   │   ├── configure_fail2ban/
│   │   ├── configure_monitoring/
│   │   └── configure_log_rotation/
│   ├── ansible.cfg          # Default secure Ansible configuration
│   ├── ansible.dev.cfg      # Development configuration
│   └── SECURITY.md          # Security documentation
├── README.md                # Project overview (this file)
└── ... (other project files)
```

## Available Playbooks

### Core Playbooks

- **`full.yml`** - Complete system deployment (recommended for new servers)
- **`update_ubuntu.yml`** - System updates and security patches
- **`deploy_docker.yml`** - Docker installation and configuration
- **`create_deployment_user.yml`** - Create dedicated deployment user
- **`disable_password_authentication.yml`** - SSH security hardening

### Security & Monitoring Playbooks

- **`configure_firewall.yml`** - UFW firewall configuration with secure Docker networks
- **`configure_docker_networks.yml`** - Create secure Docker networks with specific IP ranges
- **`configure_fail2ban.yml`** - SSH brute force protection
- **`configure_monitoring.yml`** - System monitoring and health checks
- **`configure_log_rotation.yml`** - Automated log management

## Network Security Features

### Secure Docker Networks

This project implements secure Docker network configuration:

- **Network Segmentation**: Different services run on isolated networks
- **Specific IP Ranges**: Uses defined ranges instead of broad network access
- **Default Networks**:
  - `web-network` (172.20.0.0/16): Web applications and frontend services
  - `db-network` (172.21.0.0/16): Databases and backend services
  - `monitoring-network` (172.22.0.0/16): Monitoring and logging services

### Firewall Configuration

- **Restrictive Rules**: Only allows specific Docker networks instead of broad ranges
- **Network Monitoring**: UFW logging and network traffic monitoring
- **Container Ports**: Configurable container port access
- **Security Logging**: Network activity logging and rotation

## Technologies Used

- **Ansible:** For automating server configuration and Docker installation.
- **Docker:** To enable containerized application deployment on remote servers.
- **Visual Studio Code Devcontainers:** For a reproducible and isolated development environment.
- **Ubuntu:** Target operating system for remote server setup.
- **UFW:** Uncomplicated Firewall for network security.
- **Fail2ban:** Intrusion prevention software for SSH protection.
- **SSH Host Key Verification:** Secure connection validation for production deployments.
- **Docker Networks:** Secure network segmentation for containerized applications.

## When to Use This Project

- You need to prepare remote Ubuntu servers for Docker-based deployments.
- You want to automate server setup and configuration using Ansible.
- You prefer working in a consistent, containerized development environment with Devcontainers.
- You need comprehensive server security and monitoring setup.
- You require secure, production-ready deployment configurations.
- You need secure Docker network configuration with proper segmentation.

## Quick Start

1. **Setup your environment:**

   ```bash
   # Copy and configure your inventory
   cp src/inventory/group_vars/all.example.yml src/inventory/group_vars/all.yml
   # Edit all.yml with your server details
   ```

2. **Configure host keys (required for secure deployment):**

   ```bash
   cd src
   # Add your server's host key
   ssh-keyscan -H your_server_ip >> inventory/known_hosts
   ```

3. **Run full deployment:**

   ```bash
   # Use default secure configuration
   ansible-playbook playbooks/full.yml
   
   # Or use development config for testing
   ansible-playbook --config-file ansible.dev.cfg playbooks/full.yml
   ```

4. **Configure secure networks and firewall:**

   ```bash
   # Configure secure Docker networks
   ansible-playbook playbooks/configure_docker_networks.yml
   
   # Configure firewall with secure network rules
   ansible-playbook playbooks/configure_firewall.yml
   
   # Optional security and monitoring
   ansible-playbook playbooks/configure_fail2ban.yml
   ansible-playbook playbooks/configure_monitoring.yml
   ansible-playbook playbooks/configure_log_rotation.yml
   ```

## Security Documentation

For detailed information about security configuration, host key management, network security, and troubleshooting, see `src/SECURITY.md`.

---

For more details on the playbooks, roles, or project structure, explore the respective directories in the repository.
