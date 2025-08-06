# Docker Network Ranges

## Overview

This document describes the Docker network ranges used in this project and provides guidance for other projects that need to create additional networks.

## Currently Allowed Ranges

| Range | Purpose | Status |
|-------|---------|--------|
| `172.20.0.0/16` | Web applications network | Reserved for testing |
| `172.21.0.0/16` | Database network | Reserved for testing |
| `172.22.0.0/16` | Monitoring network | Reserved for testing |

## Available Ranges for New Projects

| Range | Status | Recommended Use |
|-------|--------|-----------------|
| `172.23.0.0/16` | Available | API services |
| `172.24.0.0/16` | Available | Cache services |
| `172.25.0.0/16` | Available | Microservices |
| `172.26.0.0/16` | Available | Development |
| `172.27.0.0/16` | Available | Staging |
| `172.28.0.0/16` | Available | Production |
| `172.29.0.0/16` | Available | Backup services |
| `172.30.0.0/16` | Available | Monitoring |
| `172.31.0.0/16` | Available | Logging |

## Multi-Project User Permissions

### User Roles and Permissions

This project uses two distinct user roles for different levels of access:

#### 1. Initial Deployment User (`ubuntu`)

- **Purpose**: System-level deployment and configuration
- **Permissions**: Full system access for initial setup
- **Usage**: Only needed for the main project deployment
- **Security**: High-privilege user for system administration

#### 2. Container Deployment User (`docker_deployment`)

- **Purpose**: Docker operations and application deployment
- **Permissions**: Docker management, network operations, limited system access
- **Usage**: Used by all projects for their daily operations
- **Security**: Limited permissions following principle of least privilege

### What Other Projects Can Do

Other projects **only need the `docker_deployment` user** and can perform all necessary operations:

#### ✅ **Available Operations**

```bash
# Docker operations (no sudo needed)
docker ps
docker-compose up -d
docker network create my-network
docker network ls

# System management (with sudo)
sudo systemctl status docker
sudo ufw status
sudo ufw allow from 172.25.0.0/16

# Network management
docker network inspect my-network
docker network connect my-network container-name
```

#### ❌ **Restricted Operations**

- System package installation
- User account modification
- System configuration changes
- Ubuntu updates

### Enhanced Permissions for Container Deployment User

The `docker_deployment` user has been configured with enhanced permissions:

#### **Docker Group Membership**

- Direct access to Docker daemon
- No sudo required for Docker commands
- Full Docker management capabilities

#### **Enhanced Sudo Permissions**

```bash
# Docker management
sudo docker system prune
sudo systemctl restart docker

# Firewall management
sudo ufw allow from 172.25.0.0/16
sudo ufw status

# System monitoring
sudo systemctl status docker
sudo systemctl status ufw
```

#### **Network Management**

- Create and manage Docker networks
- Configure firewall rules for new networks
- Monitor network connectivity

### Configuration for Other Projects

#### **Minimal Required Configuration**

```yaml
# Server information
vps_server_ip: "your-server-ip"
containers_deployment_user: "docker_deployment"
containers_deployment_user_ssh_key: "~/.ssh/your-deployment-key"

# SSH configuration
ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
ansible_python_interpreter: "/usr/bin/python3.10"

# Optional: Your project's network ranges
configure_firewall_docker_networks:
  - 172.25.0.0/16  # Your project networks
  - 172.26.0.0/16  # Additional networks if needed
```

#### **What You DON'T Need**

- ❌ `initial_deployment_user` details
- ❌ `initial_deployment_ssh_key`
- ❌ System-level deployment permissions
- ❌ Ubuntu update permissions

### Security Benefits

#### **Principle of Least Privilege**

- Limited system access
- Focused on Docker operations only
- Reduced attack surface
- Isolated permissions

#### **Multi-Project Isolation**

- Each project uses same user but different networks
- Network isolation prevents conflicts
- Firewall rules isolate traffic
- No interference between projects

## Usage Instructions

### For Other Projects

1. **Check current firewall rules:**

   ```bash
   sudo ufw status | grep "172\."
   ```

2. **Choose an available range** from the table above

3. **Create your Docker network:**

   ```bash
   docker network create --subnet=172.25.0.0/16 my-project-network
   ```

4. **Add firewall rule:**

   ```bash
   sudo ufw allow from 172.25.0.0/16
   ```

5. **Verify the rule was added:**

   ```bash
   sudo ufw status verbose
   ```

### Example Workflow

```bash
# 1. Check current rules
sudo ufw status | grep "172\."

# 2. Create network for your project
docker network create --subnet=172.25.0.0/16 my-app-network

# 3. Add firewall permission
sudo ufw allow from 172.25.0.0/16

# 4. Verify
sudo ufw status verbose

# 5. Use in docker-compose.yml
networks:
  my-app-network:
    external: true
```

## Network Management Commands

### Check Current Networks

```bash
# List all Docker networks
docker network ls

# Show network details
docker network inspect network-name
```

### Check Firewall Rules

```bash
# Show all UFW rules
sudo ufw status verbose

# Show only Docker network rules
sudo ufw status | grep "172\."
```

### Remove Networks (if needed)

```bash
# Remove specific network
docker network rm network-name

# Remove unused networks
docker network prune
```

## Troubleshooting

### Network Creation Fails

- Check if range is already in use: `docker network ls`
- Verify Docker daemon is running: `sudo systemctl status docker`

### Firewall Rule Issues

- Check UFW status: `sudo ufw status`
- Verify rule syntax: `sudo ufw allow from RANGE`

### Container Communication Issues

- Check network assignment: `docker inspect container-name`
- Verify firewall rules: `sudo ufw status verbose`
- Test connectivity: `docker exec container-name ping 8.8.8.8`

### Permission Issues

- Verify user is in docker group: `groups docker_deployment`
- Check sudo permissions: `sudo -l`
- Test Docker access: `docker ps`
