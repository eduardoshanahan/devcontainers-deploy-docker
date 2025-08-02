# Ansible Playbooks

This directory contains all the Ansible playbooks for server configuration and deployment.

## Core Playbooks

### `full.yml`

Complete system deployment playbook. This is the main playbook that orchestrates the entire server setup process.

**What it does:**

- Updates Ubuntu system
- Installs Docker
- Creates deployment user
- Disables password authentication
- Configures firewall with secure networks
- Sets up Docker networks
- Configures fail2ban
- Sets up monitoring
- Configures log rotation

**Usage:**

```bash
ansible-playbook playbooks/full.yml
```

### `update_ubuntu.yml`

Updates the Ubuntu system with latest packages and security patches.

**Usage:**

```bash
ansible-playbook playbooks/update_ubuntu.yml
```

### `deploy_docker.yml`

Installs and configures Docker with secure network settings.

**Usage:**

```bash
ansible-playbook playbooks/deploy_docker.yml
```

### `create_deployment_user.yml`

Creates a dedicated deployment user with proper permissions.

**Usage:**

```bash
ansible-playbook playbooks/create_deployment_user.yml
```

### `disable_password_authentication.yml`

Hardens SSH security by disabling password authentication.

**Usage:**

```bash
ansible-playbook playbooks/disable_password_authentication.yml
```

## Security & Network Playbooks

### `configure_firewall.yml`

Configures UFW firewall with secure Docker network rules.

**Features:**

- Restricts Docker networks to specific IP ranges
- Blocks broad network ranges (172.16.0.0/12, 192.168.0.0/16, 10.0.0.0/8)
- Allows only necessary container ports
- Enables network traffic logging
- Configures log rotation for network logs

**Usage:**

```bash
ansible-playbook playbooks/configure_firewall.yml
```

### `configure_docker_networks.yml`

Creates secure Docker networks with specific IP ranges and network segmentation.

**Features:**

- Creates isolated networks for different service types
- Implements network segmentation (web, db, monitoring)
- Configures network security policies
- Provides audit trail with network labels

**Usage:**

```bash
ansible-playbook playbooks/configure_docker_networks.yml
```

### `configure_fail2ban.yml`

Configures fail2ban for SSH brute force protection.

**Usage:**

```bash
ansible-playbook playbooks/configure_fail2ban.yml
```

### `configure_monitoring.yml`

Sets up system monitoring and health checks.

**Usage:**

```bash
ansible-playbook playbooks/configure_monitoring.yml
```

### `configure_log_rotation.yml`

Configures automated log management.

**Usage:**

```bash
ansible-playbook playbooks/configure_log_rotation.yml
```

## Testing Playbooks

### `test_network_security.yml`

Comprehensive testing playbook that validates the network security implementation.

**Tests:**

- Firewall configuration validation
- Docker network creation and configuration
- Network isolation verification
- Container communication tests
- Security logging validation
- Docker daemon security settings

**Usage:**

```bash
ansible-playbook playbooks/test_network_security.yml
```

## Playbook Execution Order

For a complete secure deployment, run playbooks in this order:

1. **Initial Setup:**

   ```bash
   ansible-playbook playbooks/update_ubuntu.yml
   ansible-playbook playbooks/create_deployment_user.yml
   ansible-playbook playbooks/disable_password_authentication.yml
   ```

2. **Docker and Network Setup:**

   ```bash
   ansible-playbook playbooks/deploy_docker.yml
   ansible-playbook playbooks/configure_docker_networks.yml
   ansible-playbook playbooks/configure_firewall.yml
   ```

3. **Security and Monitoring:**

   ```bash
   ansible-playbook playbooks/configure_fail2ban.yml
   ansible-playbook playbooks/configure_monitoring.yml
   ansible-playbook playbooks/configure_log_rotation.yml
   ```

4. **Validation:**

   ```bash
   ansible-playbook playbooks/test_network_security.yml
   ```

## Manual Testing

For manual validation, use the provided test script:

```bash
chmod +x scripts/test_network_security.sh
./scripts/test_network_security.sh
```

## Troubleshooting

### Common Issues

1. **Firewall blocks Docker communication**
   - Check UFW status: `sudo ufw status`
   - Verify Docker networks are allowed: `sudo ufw status numbered`

2. **Containers cannot communicate**
   - Check network assignment: `docker network ls`
   - Verify container networks: `docker inspect container-name`

3. **Test playbook fails**
   - Ensure Docker is running: `sudo systemctl status docker`
   - Check network creation: `docker network ls`
   - Verify firewall configuration: `sudo ufw status verbose`

### Debug Commands

```bash
# Check firewall status
sudo ufw status verbose

# List Docker networks
docker network ls

# Check container networks
docker inspect container-name

# View network logs
sudo tail -f /var/log/ufw.log

# Test network connectivity
docker exec container-name ping host
```

## Security Notes

- All playbooks use secure SSH configuration
- Firewall rules are restrictive by default
- Docker networks are isolated and segmented
- Network traffic is logged and monitored
- Security settings are validated by tests

For detailed security information, see `src/SECURITY.md`.
