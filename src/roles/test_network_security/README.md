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

## Dependencies

- Requires Docker to be installed and running
- Requires firewall configuration to be completed
- Requires Docker networks to be created
