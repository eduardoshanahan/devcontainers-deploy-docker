# Test Network Security Role

This role validates the network security implementation by testing firewall rules, Docker networks, and network isolation.

## What it tests

- **Firewall Configuration**: Validates UFW rules and Docker network access
- **Docker Networks**: Tests network creation and connectivity
- **Network Isolation**: Verifies that services are properly isolated
- **Security Logging**: Checks network monitoring and logging
- **Container Communication**: Tests inter-container and cross-network communication

## Test Categories

### 1. Firewall Tests

- UFW status and rules validation
- Docker network range restrictions
- Container port access verification
- Network traffic logging validation

### 2. Docker Network Tests

- Network creation and configuration
- Network isolation verification
- Cross-network communication tests
- Network security policy validation

### 3. Container Security Tests

- Container network assignment
- Inter-container communication
- Network policy enforcement
- Security label validation

### 4. Monitoring Tests

- Network traffic logging
- UFW log rotation
- Network activity monitoring
- Security alert validation

## Configuration Variables

```yaml
# Test configuration
test_network_security_enabled: true
test_network_security_timeout: 30

# Expected networks (from configuration)
test_network_security_expected_networks: "{{ deploy_docker_network_configuration.default_networks }}"
```

## Test Results

The role provides detailed test results including:

- Pass/Fail status for each test
- Detailed error messages for failures
- Network configuration validation
- Security policy compliance checks

## Usage

Run the testing playbook after implementing network security:

```bash
ansible-playbook playbooks/test_network_security.yml
```

## Manual Testing

For manual validation, use the provided test script:

```bash
# Run the configurable test script
sudo /opt/security-updates/test_network_security.sh
```

## Dependencies

- Requires Docker to be installed and running
- Requires firewall configuration to be completed
- Requires Docker networks to be created

## Test Containers

The role creates temporary test containers:

- **test-web**: Alpine container on web-network
- **test-db**: Alpine container on db-network
- **test-monitoring**: Alpine container on monitoring-network

## Cleanup

Test containers are automatically cleaned up after testing.

## Troubleshooting

- **Docker not running**: Start Docker service
- **Firewall not configured**: Run firewall configuration first
- **Networks not created**: Run Docker networks configuration
- **Test failures**: Check individual test error messages
