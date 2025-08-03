# Deploy Docker Role

This role installs and configures Docker on Ubuntu systems with proper security settings and network configuration.

## What it does

- Installs Docker prerequisites (apt-transport-https, ca-certificates, curl, etc.)
- Adds Docker's official GPG key
- Configures Docker repository
- Installs Docker Engine and containerd
- Starts and enables Docker service
- Adds deployment user to docker group
- Configures Docker daemon with security settings
- Sets up network configuration and policies
- Displays Docker and Docker Compose versions

## Docker Configuration

- **Repository**: Official Docker repository for Ubuntu
- **Packages**: docker-ce, docker-ce-cli, containerd.io
- **Service**: Enabled and started automatically
- **User permissions**: Deployment user added to docker group
- **Security**: Hardened Docker daemon configuration
- **Networking**: Configurable network policies and isolation

## Version Information

The role displays:

- Docker version after installation
- Docker Compose availability and version
- Service status information

## Docker Compose

- Checks if Docker Compose is available
- Displays version information if present
- Works with both Docker Compose v1 and v2

## Security Features

- Uses official Docker GPG key for package verification
- Installs from official Docker repository
- Proper user group permissions for Docker access
- Hardened Docker daemon configuration
- Network isolation and security policies
- Bridge netfilter enabled for iptables rules

## Configuration

### Role Behavior Settings (Role Defaults)

These control how the role behaves and are defined in the role defaults:

```yaml
# In role defaults/main.yml
deploy_docker_security_enabled: true
deploy_docker_packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
```

### Environment-Specific Settings (Inventory Variables)

These define the actual network configurations and are set in your inventory:

```yaml
# In inventory/group_vars/all.yml
deploy_docker_network_configuration:
  default_networks:
    - name: "web-network"
      subnet: "172.20.0.0/16"
      driver: "bridge"
      description: "Network for web applications"
  network_isolation: true
  default_container_network: "web-network"
  network_security:
    enable_bridge_netfilter: true
    enable_ip_forwarding: true
    enable_network_isolation: true

deploy_docker_network_policies:
  web_services:
    - "nginx"
    - "apache"
    - "nodejs"
  database_services:
    - "postgres"
    - "mysql"
    - "redis"
```

## Variable Organization

### Role Defaults (Behavior Settings)
- **Location**: `src/roles/deploy_docker/defaults/main.yml`
- **Purpose**: Control role behavior and provide sensible defaults
- **Override**: Rarely changed, role-specific logic

### Inventory Variables (Environment Configuration)
- **Location**: `src/inventory/group_vars/all.yml`
- **Purpose**: Define network configurations and policies
- **Override**: Environment-specific, frequently customized

## Usage

### Standard Deployment

```bash
# Deploy Docker with default configuration
ansible-playbook playbooks/deploy_docker.yml
```

### Custom Network Configuration

```yaml
# In inventory/group_vars/all.yml
deploy_docker_network_configuration:
  default_networks:
    - name: "my-web-network"
      subnet: "10.0.1.0/24"
      driver: "bridge"
      description: "My custom web network"
    - name: "my-db-network"
      subnet: "10.0.2.0/24"
      driver: "bridge"
      description: "My custom database network"
  network_isolation: true
  default_container_network: "my-web-network"
```

## Docker Daemon Configuration

The role configures the Docker daemon with:

- **Security settings**: Bridge netfilter, IP forwarding
- **Network policies**: Service categorization and isolation
- **Default networks**: Pre-configured network ranges
- **User permissions**: Proper group assignments

## Network Security

- **Bridge Netfilter**: Enables iptables rules on bridge interfaces
- **IP Forwarding**: Allows controlled container communication
- **Network Isolation**: Separates different service types
- **Security Policies**: Service-specific network rules

## Troubleshooting

### Docker Service Issues

- Check if Docker service is running: `sudo systemctl status docker`
- Verify user is in docker group: `groups $USER`
- Check Docker daemon logs: `sudo journalctl -u docker`

### Network Configuration Issues

- Verify network configuration: `docker network ls`
- Check network policies: `docker network inspect <network>`
- Test container connectivity: `docker run --rm alpine ping -c 1 8.8.8.8`

### Permission Issues

- Ensure user is in docker group: `sudo usermod -aG docker $USER`
- Log out and back in for group changes to take effect
- Test Docker access: `docker ps`

## Benefits

1. **Secure Installation**: Uses official Docker repository and GPG keys
2. **Proper Configuration**: Hardened Docker daemon settings
3. **Network Security**: Configurable network isolation and policies
4. **User Management**: Proper group permissions and access control
5. **Flexibility**: Customizable network configurations per environment

## Summary

This role provides a **secure and properly configured** Docker installation with network security features and flexible configuration options. It follows best practices for Docker deployment while allowing customization for different environments.
