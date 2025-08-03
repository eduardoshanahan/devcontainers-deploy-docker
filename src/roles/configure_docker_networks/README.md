# Configure Docker Networks Role

This role validates Docker network configuration and ensures proper network setup without imposing a predefined network structure.

## What it does

- Validates Docker network configuration
- Tests network connectivity and functionality
- **Removes all created networks after testing** (no imposition)
- Ensures Docker daemon is properly configured for networking
- Validates network security settings

## Key Features

### No Network Imposition

- **Test Mode**: Creates networks temporarily for validation
- **Automatic Cleanup**: Removes all created networks after testing
- **User Control**: Users define their own network architecture
- **Validation Only**: Ensures Docker networking works without forcing structure

### Network Validation

- **Connectivity Testing**: Validates network communication
- **Configuration Testing**: Ensures proper Docker daemon settings
- **Security Validation**: Confirms network security policies
- **Clean State**: Leaves system in clean state after testing

## Configuration

### Role Behavior Settings (Role Defaults)

These control how the role behaves and are defined in the role defaults:

```yaml
# In role defaults/main.yml
configure_docker_networks_test_mode: true
configure_docker_networks_default_driver: "bridge"
configure_docker_networks_remove_all: false
configure_docker_networks_encrypted: false
```

### Network Configuration (Inventory Variables)

These define the actual networks and are set in your inventory:

```yaml
# In inventory/group_vars/all.yml
configure_docker_networks_default_networks:
  - name: "web-network"
    subnet: "172.20.0.0/16"
    driver: "bridge"
    description: "Network for web applications"
  - name: "db-network"
    subnet: "172.21.0.0/16"
    driver: "bridge"
    description: "Network for databases"

configure_docker_networks_custom_networks:
  - name: "api-network"
    subnet: "172.23.0.0/16"
    driver: "bridge"
    description: "API services network"
```

## Variable Organization

### Role Defaults (Behavior Settings)

- **Location**: `src/roles/configure_docker_networks/defaults/main.yml`
- **Purpose**: Control role behavior and provide sensible defaults
- **Override**: Rarely changed, role-specific logic

### Inventory Variables (Network Configuration)

- **Location**: `src/inventory/group_vars/all.yml`
- **Purpose**: Define actual network configurations
- **Override**: Environment-specific, frequently customized

## Usage

### Standard Deployment (Recommended)

```bash
# Deploy with test mode (creates networks, tests, then removes them)
ansible-playbook playbooks/configure_docker_networks.yml
```

### Custom Network Configuration

```yaml
# In inventory/group_vars/all.yml
configure_docker_networks_default_networks:
  - name: "my-web-network"
    subnet: "10.0.1.0/24"
    driver: "bridge"
    description: "My custom web network"
  - name: "my-db-network"
    subnet: "10.0.2.0/24"
    driver: "bridge"
    description: "My custom database network"
```

### Manual Network Creation

After deployment, create your own networks:

```bash
# Create your own networks
docker network create my-web-network --subnet=10.0.1.0/24
docker network create my-db-network --subnet=10.0.2.0/24
```

## Benefits

1. **No Imposition**: Users control their own network architecture
2. **Validation**: Ensures Docker networking works correctly
3. **Clean State**: No leftover networks from deployment
4. **Flexibility**: Supports any network topology
5. **Testing**: Validates network functionality without forcing structure
6. **Organization**: Clear separation of behavior vs. configuration

## Security Features

- **Network Isolation**: Validates proper network segmentation
- **Security Policies**: Confirms network security settings
- **Clean Environment**: No unintended network exposure
- **Audit Trail**: Logs all network operations for review

## Troubleshooting

### Networks Not Created

- This is expected behavior in test mode
- Networks are created temporarily for testing only
- Create your own networks after deployment

### Network Validation Failed

- Check Docker daemon configuration
- Verify network driver support
- Review firewall settings

### Configuration Issues

- Verify network configurations in inventory
- Check subnet conflicts
- Ensure proper YAML syntax

## Summary

This role provides **validation without imposition**. It ensures Docker networking works correctly while giving users complete control over their network architecture. No predefined networks remain after deployment.

**Variable Organization**:

- **Role defaults**: Behavior settings (test mode, drivers)
- **Inventory variables**: Network configurations (subnets, names)
