# Project Overview: Remote Docker Installation with Ansible & Devcontainers

## Why I have this project

I needed a way to fire up a fresh VPS with Ubuntu, update it and deploy Docker to later run services in containers. I also wanted to be able to update an existing server. And I want to be able to work inside a devcontainer.

## Purpose

- **Automate server preparation:** Seamlessly update Ubuntu and install Docker on remote servers using Ansible playbooks.
- **Enable containerized deployments:** Set up servers to be ready for containerized applications, reducing manual configuration and potential errors.
- **Leverage Devcontainers:** Use Visual Studio Code Devcontainers for a consistent development and automation environment.

## Key Features

- **Ansible Playbooks:** Automate the update and configuration of Ubuntu servers, including Docker installation and essential system settings.
- **Devcontainer Integration:** Provides a ready-to-use development environment with all necessary tools and configurations for working with Ansible and Docker.
- **Modular Roles:** Organized Ansible roles for tasks such as Docker installation, firewall configuration, monitoring, and more.
- **Inventory Management:** Flexible inventory structure for managing multiple remote servers.

## Project Structure

```text
git-base/
├── .devcontainer/           # Devcontainer configuration for VS Code
│   ├── Dockerfile
│   ├── devcontainer.json
│   ├── .env.example
│   └── settings.json
├── launch_vscode.sh         # Script to launch VS Code with the Dev Container
├── src/
│   ├── inventory/           # Ansible inventory and group variables
│   ├── playbooks/           # Ansible playbooks
│   ├── roles/               # Ansible roles (Docker, firewall, monitoring, etc.)
│   ├── ansible.cfg          # Ansible configuration
│   └── run_all.yml          # Main playbook entry point
├── README.md                # Project overview (this file)
└── ... (other project files)
```

## Technologies Used

- **Ansible:** For automating server configuration and Docker installation.
- **Docker:** To enable containerized application deployment on remote servers.
- **Visual Studio Code Devcontainers:** For a reproducible and isolated development environment.
- **Ubuntu:** Target operating system for remote server setup.

## When to Use This Project

- You need to prepare remote Ubuntu servers for Docker-based deployments.
- You want to automate server setup and configuration using Ansible.
- You prefer working in a consistent, containerized development environment with Devcontainers.

---

For more details on the playbooks, roles, or project structure, explore the respective directories in the repository.
