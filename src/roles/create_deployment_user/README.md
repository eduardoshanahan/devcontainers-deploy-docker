# Create Deployment User Role

This role creates a dedicated user for container deployments with SSH access and sudo privileges.

## What it does

- Creates the deployment user (`docker_deployment`)
- Sets up SSH directory with proper permissions (700)
- Installs SSH public key for authentication
- Configures passwordless sudo access
- Validates SSH key existence before installation

## User Configuration

- **Username**: `docker_deployment` (configurable via `containers_deployment_user`)
- **Shell**: `/bin/bash`
- **Home directory**: `/home/docker_deployment`
- **SSH key**: Uses `containers_deployment_user_ssh_key_public`
- **Sudo access**: Passwordless sudo privileges

## Security Features

- Proper file permissions for SSH directory
- Key-based authentication only
- Dedicated user for deployments (principle of least privilege)
- Sudo access for container management

## Configuration Variables

```yaml
# User configuration
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key_public: "/path/to/your/public/key.pub"
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
- **Sudo access**: Limited to container management tasks
- **Proper permissions**: SSH directory with 700 permissions

## Files Created

- `/home/docker_deployment/` - User home directory
- `/home/docker_deployment/.ssh/` - SSH directory
- `/home/docker_deployment/.ssh/authorized_keys` - SSH public key
- `/etc/sudoers.d/docker_deployment` - Sudo configuration

## Troubleshooting

- **SSH key issues**: Verify key file exists and is readable
- **Permission issues**: Check SSH directory permissions
- **Sudo access**: Verify sudo configuration is correct
