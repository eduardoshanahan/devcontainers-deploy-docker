# Ansible Playbooks

This directory contains Ansible playbooks for server provisioning and configuration.

## Prerequisites

- Ensure you're in the project root directory: `/workspace/src`
- Verify your SSH keys are properly configured
- Check that your inventory files are set up correctly

## Available Playbooks

### 1. Update Ubuntu System (`update_ubuntu.yml`)

Updates the Ubuntu system packages and performs system upgrades.

```bash
ansible-playbook playbooks/update_ubuntu.yml
```

**What it does:**

- Updates package cache (`apt update`)
- Upgrades all packages (`apt upgrade`)

### 2. Disable Password Authentication (`disable_password_authentication.yml`)

Secures SSH configuration by disabling password authentication and other security measures.

```bash
ansible-playbook playbooks/disable_password_authentication.yml
```

**What it does:**

- Disables password authentication (key-based only)
- Disables root login
- Disables empty passwords
- Validates SSH configuration
- Restarts SSH service

**Important:** Ensure your SSH key authentication is working before running this playbook.

### 3. Create Deployment User (`create_deployment_user.yml`)

Creates a new user for container deployments with SSH access and sudo privileges.

```bash
ansible-playbook playbooks/create_deployment_user.yml
```

**What it does:**

- Creates the deployment user (`docker_deployment`)
- Sets up SSH directory with proper permissions
- Installs SSH public key for authentication
- Configures passwordless sudo access

### 4. Deploy Docker (`deploy_docker.yml`)

Installs and configures Docker on the system.

```bash
ansible-playbook playbooks/deploy_docker.yml
```

**What it does:**

- Installs Docker prerequisites
- Adds Docker's official GPG key and repository
- Installs Docker Engine and containerd
- Starts and enables Docker service
- Adds deployment user to docker group
- Displays Docker and Docker Compose versions

### 5. Configure Firewall (`configure_firewall.yml`)

Configures UFW (Uncomplicated Firewall) for basic network security.

```bash
ansible-playbook playbooks/configure_firewall.yml
```

**What it does:**

- Installs and configures UFW
- Sets up basic firewall rules
- Enables SSH access
- Activates the firewall

### 6. Configure Fail2ban (`configure_fail2ban.yml`)

Sets up fail2ban for SSH brute force protection.

```bash
ansible-playbook playbooks/configure_fail2ban.yml
```

**What it does:**

- Installs and configures fail2ban
- Sets up SSH protection rules
- Configures jail settings
- Starts and enables fail2ban service

### 7. Configure Monitoring (`configure_monitoring.yml`)

Sets up basic system monitoring tools.

```bash
ansible-playbook playbooks/configure_monitoring.yml
```

**What it does:**

- Installs monitoring tools
- Configures system monitoring
- Sets up basic alerting

### 8. Configure Log Rotation (`configure_log_rotation.yml`)

Configures log rotation for disk space management.

```bash
ansible-playbook playbooks/configure_log_rotation.yml
```

**What it does:**

- Configures logrotate
- Sets up log rotation policies
- Manages disk space usage

### 9. Full Deployment (`full.yml`)

Runs all core playbooks in the correct sequence for a complete system setup.

```bash
ansible-playbook playbooks/full.yml
```

**What it does:**

1. Updates Ubuntu system
2. Secures SSH configuration
3. Creates deployment user
4. Installs and configures Docker

**Note:** This does not include the additional security and monitoring playbooks. Run them separately if needed.

## Running Playbooks

### Basic Usage

```bash
# From the project root directory
cd /workspace/src

# Run a specific playbook
ansible-playbook playbooks/playbook_name.yml

# Run with verbose output
ansible-playbook playbooks/playbook_name.yml -v

# Run with extra verbose output
ansible-playbook playbooks/playbook_name.yml -vv

# Dry run (check mode)
ansible-playbook playbooks/playbook_name.yml --check
```

### Targeting Specific Hosts

```bash
# Run against specific host
ansible-playbook playbooks/playbook_name.yml --limit vps

# Run against specific group
ansible-playbook playbooks/playbook_name.yml --limit host_tasks
```

### Troubleshooting

```bash
# Test SSH connection
ansible all -m ping

# Check inventory
ansible-inventory --list

# Validate playbook syntax
ansible-playbook playbooks/playbook_name.yml --syntax-check
```

## Playbook Order

For a fresh server setup, run playbooks in this order:

1. `update_ubuntu.yml` - System updates
2. `disable_password_authentication.yml` - SSH security
3. `create_deployment_user.yml` - Create deployment user
4. `deploy_docker.yml` - Install Docker
5. `configure_firewall.yml` - Basic firewall (optional)
6. `configure_fail2ban.yml` - SSH protection (optional)
7. `configure_monitoring.yml` - System monitoring (optional)
8. `configure_log_rotation.yml` - Log management (optional)

Or simply run `full.yml` which executes the core roles in the correct sequence.

## Configuration

All playbooks use variables defined in:

- `inventory/group_vars/all.yml` - Global variables
- `ansible.cfg` - Ansible configuration

Make sure these files are properly configured before running playbooks.
