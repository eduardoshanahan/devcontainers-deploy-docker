# Project Overview: Remote Docker Installation with Ansible & Devcontainers

## Why I have this project

I needed a way to fire up a fresh VPS with Ubuntu, update it and deploy Docker to later run services in containers. I also wanted to be able to update an existing server. And I want to be able to work inside a devcontainer. And I like Ansible a lot more than I like Bash.

## Purpose

- **Automate server preparation:** Update Ubuntu and install Docker on remote servers using Ansible playbooks.
- **Enable containerized deployments:** Set up servers to be ready for containerized applications, reducing manual configuration and potential errors.
- **Leverage Devcontainers:** Use Visual Studio Code Devcontainers for a consistent development and automation environment.

## Key Features

- **Ansible Playbooks:** Automate the update and configuration of Ubuntu servers, including Docker installation and essential system settings.
- **Devcontainer Integration:** Provides a ready-to-use development environment with all necessary tools and configurations for working with Ansible and Docker.
- **Modular Roles:** Organized Ansible roles for tasks such as Docker installation, firewall configuration, monitoring, and more.
- **Inventory Management:** Inventory structure for managing multiple remote servers.
- **Security Features:** Built-in security configurations including SSH hardening, firewall setup, and fail2ban protection.
- **Monitoring & Maintenance:** Automated monitoring, log rotation, and system health checks.

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
│   │   └── group_vars/      # Global variables
│   ├── playbooks/           # Ansible playbooks
│   │   ├── full.yml         # Complete system deployment
│   │   ├── update_ubuntu.yml
│   │   ├── deploy_docker.yml
│   │   ├── configure_firewall.yml
│   │   ├── configure_fail2ban.yml
│   │   ├── configure_monitoring.yml
│   │   └── configure_log_rotation.yml
│   ├── roles/               # Ansible roles
│   │   ├── update_ubuntu/
│   │   ├── deploy_docker/
│   │   ├── create_deployment_user/
│   │   ├── disable_password_authentication/
│   │   ├── configure_firewall/
│   │   ├── configure_fail2ban/
│   │   ├── configure_monitoring/
│   │   └── configure_log_rotation/
│   └── ansible.cfg          # Ansible configuration
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

- **`configure_firewall.yml`** - UFW firewall configuration
- **`configure_fail2ban.yml`** - SSH brute force protection
- **`configure_monitoring.yml`** - System monitoring and health checks
- **`configure_log_rotation.yml`** - Automated log management

## Technologies Used

- **Ansible:** For automating server configuration and Docker installation.
- **Docker:** To enable containerized application deployment on remote servers.
- **Visual Studio Code Devcontainers:** For a reproducible and isolated development environment.
- **Ubuntu:** Target operating system for remote server setup.
- **UFW:** Uncomplicated Firewall for network security.
- **Fail2ban:** Intrusion prevention software for SSH protection.

## When to Use This Project

- You need to prepare remote Ubuntu servers for Docker-based deployments.
- You want to automate server setup and configuration using Ansible.
- You prefer working in a consistent, containerized development environment with Devcontainers.
- You need comprehensive server security and monitoring setup.

## Quick Start

1. **Setup your environment:**

   ```bash
   # Copy and configure your inventory
   cp src/inventory/group_vars/all.example.yml src/inventory/group_vars/all.yml
   # Edit all.yml with your server details
   ```

2. **Run full deployment:**

   ```bash
   cd src
   ansible-playbook playbooks/full.yml
   ```

3. **Optional security and monitoring:**

   ```bash
   ansible-playbook playbooks/configure_firewall.yml
   ansible-playbook playbooks/configure_fail2ban.yml
   ansible-playbook playbooks/configure_monitoring.yml
   ansible-playbook playbooks/configure_log_rotation.yml
   ```

---

For more details on the playbooks, roles, or project structure, explore the respective directories in the repository.
