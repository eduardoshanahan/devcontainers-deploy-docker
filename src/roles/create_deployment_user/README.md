# Create Deployment User Role

This role creates a dedicated user for container deployments with SSH access and enhanced but restricted sudo privileges.

## What it does

- Creates the deployment user (`docker_deployment`)
- Sets up SSH directory with proper permissions (700)
- Installs SSH public key for authentication
- Configures enhanced restricted sudo access (no full sudo)
- Validates SSH key existence before installation

## User Configuration

- **Username**: `docker_deployment` (configurable via `containers_deployment_user`)
- **Shell**: `/bin/bash`
- **Home directory**: `/home/docker_deployment`
- **SSH key**: Uses `containers_deployment_user_ssh_key_public`
- **Groups**: `docker` only (no sudo group)
- **Sudo access**: Enhanced but restricted permissions

## Security Features

- Proper file permissions for SSH directory
- Key-based authentication only
- Dedicated user for deployments (principle of least privilege)
- Enhanced sudo access for Docker operations only
- No full sudo access - restricted to specific commands

## Enhanced Sudo Permissions

The deployment user can execute:

### Docker Operations

- `/usr/bin/docker` - All Docker commands
- `/usr/bin/docker-compose` - Docker Compose v1
- `/usr/bin/docker compose` - Docker Compose v2

### Docker Service Management

- `/usr/bin/systemctl reload docker` - Reload Docker daemon
- `/usr/bin/systemctl status docker` - Check Docker status
- `/usr/bin/systemctl is-active docker` - Check if Docker is active
- `/usr/bin/systemctl restart docker` - Restart Docker service

### System Updates (Docker-related only)

- `/usr/bin/apt update` - Update package lists
- `/usr/bin/apt upgrade` - Upgrade packages
- `/usr/bin/apt install --only-upgrade docker-ce` - Update Docker Engine
- `/usr/bin/apt install --only-upgrade docker-ce-cli` - Update Docker CLI
- `/usr/bin/apt install --only-upgrade containerd.io` - Update containerd

### Network Management

- `/usr/bin/ufw allow from 172.20.0.0/16` - Allow web network
- `/usr/bin/ufw allow from 172.21.0.0/16` - Allow database network
- `/usr/bin/ufw allow from 172.22.0.0/16` - Allow monitoring network
- `/usr/bin/ufw status` - Check firewall status
- `/usr/bin/ufw status verbose` - Detailed firewall status

### System Monitoring

- `/usr/bin/journalctl -u docker` - View Docker logs
- `/usr/bin/journalctl -u docker --follow` - Follow Docker logs
- `/usr/bin/journalctl -u docker --since="1 hour ago"` - Recent Docker logs

## Configuration Variables

```yaml
# User configuration
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key_public: "/path/to/your/public/key.pub"

# Enhanced permissions (optional)
docker_user_enhanced_permissions: true
docker_user_network_management: true
docker_user_system_monitoring: true
```

## Prerequisites

- SSH public key must exist at the specified path
- Initial deployment user must have sudo privileges

## Error Handling

- Validates SSH key file existence before installation
- Fails gracefully if key file is missing
- Provides clear error messages for troubleshooting

## Usage

```bash
# Run individually
ansible-playbook playbooks/create_deployment_user.yml

# Or as part of full deployment
ansible-playbook playbooks/full.yml
```

## Security Best Practices

- **Principle of least privilege**: Dedicated user for deployments
- **Key-based authentication**: No password access
- **Enhanced but restricted sudo**: No full system access
- **Proper permissions**: SSH directory with 700 permissions
- **Docker group membership**: Direct Docker access without sudo

## Files Created

- `/home/docker_deployment/` - User home directory
- `/home/docker_deployment/.ssh/` - SSH directory
- `/home/docker_deployment/.ssh/authorized_keys` - SSH public key
- `/etc/sudoers.d/docker_deployment` - Enhanced restricted sudo configuration

## Benefits of Enhanced Permissions

1. **No full sudo access** - Still maintains security
2. **Complete Docker operations** - All Docker commands available
3. **System updates possible** - Can update Docker packages
4. **Network management** - Can manage firewall rules for Docker networks
5. **Monitoring capabilities** - Can view Docker logs and system status
6. **Other project compatibility** - Works with projects requiring Docker operations

## Troubleshooting

- **SSH key issues**: Verify key file exists and is readable
- **Permission issues**: Check SSH directory permissions
- **Sudo access**: Verify sudo configuration is correct
- **Docker access**: Ensure user is in docker group
