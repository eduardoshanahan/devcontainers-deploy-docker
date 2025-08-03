# Configure Docker Networks Role

This role creates secure Docker networks with specific IP ranges and network segmentation.

## What it does

- Creates Docker networks with specific IP ranges
- Configures network isolation and security
- Sets up custom networks for different service types
- Applies network labels and descriptions
- Validates network connectivity

## Network Architecture

### Default Networks

- **web-network** (172.20.0.0/16): For web applications and frontend services
- **db-network** (172.21.0.0/16): For databases and backend services
- **monitoring-network** (172.22.0.0/16): For monitoring and logging services

### Custom Networks

- **api-network** (172.23.0.0/16): API services network
- **cache-network** (172.24.0.0/16): Cache and session storage network

## Security Features

- **Network segmentation**: Isolated networks for different service types
- **Specific IP ranges**: No broad network access (172.16.0.0/12, etc.)
- **Network isolation**: Services can only communicate within their designated networks
- **Security labels**: Network metadata for organization

## Configuration Variables

```yaml
# Network configuration
configure_docker_networks_default_networks: "{{ deploy_docker_network_configuration.default_networks }}"
configure_docker_networks_custom_networks: "{{ configure_docker_networks_custom_networks | default([]) }}"
configure_docker_networks_remove_all: false
```

## Network Management

### Remove Project Networks Only (Default)

```bash
ansible-playbook playbooks/configure_docker_networks.yml
```

### Remove All Networks

```yaml
# Add to your all.yml
configure_docker_networks_remove_all: true
```

## Usage

```bash
# Run individually
ansible-playbook playbooks/configure_docker_networks.yml

# Or as part of full deployment
ansible-playbook playbooks/full.yml
```

## Network Validation

Test network connectivity:

```bash
# List networks
docker network ls

# Inspect network
docker network inspect web-network

# Test connectivity
docker run --rm --network web-network alpine ping -c 1 8.8.8.8
```

## Network Policies

### Web Services

- nginx, apache, nodejs, react, vue

### Database Services

- postgres, mysql, redis, mongodb

### Monitoring Services

- prometheus, grafana, elasticsearch, kibana

## Troubleshooting

- **Network conflicts**: Use `configure_docker_networks_remove_all: true`
- **Subnet issues**: Check network ranges in `all.yml`
- **Connectivity problems**: Verify network isolation is working
- **Container communication**: Test cross-network isolation

## Files Created

- Docker networks with specific subnets
- Network labels and descriptions
- Network isolation policies
