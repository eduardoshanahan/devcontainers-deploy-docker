# Group Variables Configuration

This directory contains global variables that apply to all hosts in your Ansible inventory.

## Files

### `all.example.yml`

This is a template file showing the required variables for the Ansible playbooks. Copy this file to `all.yml` and configure it with your actual values.

### `all.yml` (not in git)

Your actual configuration file with real values. This file is ignored by git for security reasons.

## Required Variables

### Server Configuration

- `vps_server_ip`: Your VPS server's IP address or hostname
- `initial_deployment_user`: Username for initial server access
- `initial_deployment_ssh_key`: Path to SSH private key for initial deployment

### Container Deployment User

- `containers_deployment_user`: Username for container deployments
- `containers_deployment_user_ssh_key`: Path to SSH private key for container user
- `containers_deployment_user_ssh_key_public`: Path to SSH public key for container user

### Ansible Configuration

- `ansible_ssh_common_args`: SSH connection options
- `ansible_python_interpreter`: Python interpreter path on target server

## Setup Instructions

1. Copy the example file:

   ```bash
   cp src/inventory/group_vars/all.example.yml src/inventory/group_vars/all.yml
   ```

2. Edit `all.yml` with your actual values:

   ```yaml
   vps_server_ip: "your-actual-server-ip"
   initial_deployment_user: "ubuntu"
   initial_deployment_ssh_key: "~/.ssh/your-private-key"
   # ... configure other variables
   ```

3. Ensure your SSH keys exist and have correct permissions:

   ```bash
   chmod 600 ~/.ssh/your-private-key
   ```

## Security Notes

- Never commit `all.yml` to git (it's in `.gitignore`)
- Keep your SSH keys secure
- Use different keys for initial deployment and container deployment
- The `all.example.yml` file contains no sensitive information

## Variable Usage

These variables are used throughout the playbooks to:

- Connect to your server
- Create deployment users
- Configure SSH access
- Set up Docker permissions
- Configure monitoring and security settings
