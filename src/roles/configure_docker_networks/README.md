# Configure Docker Networks Role

This role creates custom Docker networks with specific IP ranges for better security and network segmentation.

## What it does

- Creates custom Docker networks with specific IP ranges
- Implements network segmentation for different service types
- Ensures networks are properly configured before container deployment
- Provides network isolation and security

## Network Configuration

### Default Networks

The role creates these networks by default:

- **web-network** (172.20.0.0/16): For web applications and frontend services
- **db-network** (172.21.0.0/16): For databases and backend services  
- **monitoring-network** (172.22.0.0/16): For monitoring and logging services

### Customizing Networks

To add or modify networks, set the `configure_docker_networks_custom_networks` variable:

```yaml
configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
  - name: "cache-network" 
    subnet: "172.24.0.0/16"
    driver: "bridge"
```

## Security Features

- **Network Segmentation**: Different services run on isolated networks
- **Specific IP Ranges**: No broad network ranges like 172.16.0.0/12
- **Controlled Communication**: Only necessary inter-network communication
- **Audit Trail**: Network creation is logged and tracked

## Usage

This role should be run after Docker installation but before container deployment:

```bash
ansible-playbook playbooks/configure_docker_networks.yml
```

## Dependencies

- Requires Docker to be installed and running
- Requires the deployment user to have Docker permissions
