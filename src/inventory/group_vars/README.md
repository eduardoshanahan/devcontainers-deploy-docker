# Centralized Configuration System

## Overview

This directory now contains a centralized configuration system that organizes all behavior flags and feature toggles in a logical, hierarchical structure. The system uses variable references to separate behavior configuration from environment-specific values.

## Files

### `features.yml` - Master Configuration File

This is the main configuration file that contains all behavior flags organized by feature category. It references environment-specific values from `all.yml`.

### `variable_mapping.yml` - Migration Reference

Shows how old scattered variables map to the new centralized structure.

### `all.example.yml` - Legacy Configuration

The original configuration file (still supported for backward compatibility).

### `all.yml` - Environment-Specific Values

Your actual environment configuration with real values (not in git for security).

## Variable Reference System

### How It Works

The `features.yml` file uses Ansible variable references to pull values from `all.yml`:

```yaml
# In features.yml - references values from all.yml
notifications:
  email:
    gmail_enabled: "{{ configure_security_updates_gmail_enabled | default(false) }}"
    gmail_user: "{{ configure_security_updates_gmail_user | default('') }}"

# In all.yml - actual environment values
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-actual-email@gmail.com"
```

### Benefits of this pattern

- **Separation of Concerns**: Behavior configuration vs environment values
- **Security**: Sensitive data stays in `all.yml` (not in git)
- **Flexibility**: Easy to change environment values without touching behavior
- **Defaults**: Sensible defaults when values aren't provided
- **Backward Compatibility**: Works with existing variable structure

## Benefits

### Single Point of Control

All behavior flags are now in one place, making it easy to:

- Enable/disable entire feature categories
- Understand feature dependencies
- Configure the entire system at once

### Logical Organization

Features are organized by category:

- **Security**: Updates, SSH, firewall, fail2ban
- **Monitoring**: Core monitoring, Docker monitoring, resource limits
- **Reporting**: Daily/weekly/monthly reports, content configuration
- **Containers**: Docker deployment, security, networks
- **Logging**: Remote logging, log download, rotation
- **Notifications**: Email, webhooks

### Hierarchical Structure

```yaml
features:
  security: true      # Master toggle for all security features
  monitoring: true    # Master toggle for all monitoring features
  reporting: true     # Master toggle for all reporting features

security:
  updates:
    enabled: true     # Specific feature toggle
    auto_reboot: false
```

## Usage

### Quick Configuration

```yaml
# Disable all monitoring features
features:
  monitoring: false

# Enable only security and containers
features:
  security: true
  monitoring: false
  reporting: false
  containers: true
  networking: true
  logging: false
```

### Granular Configuration

```yaml
# Enable monitoring but disable Prometheus
monitoring:
  core:
    enabled: true
  prometheus:
    enabled: false
```

### Environment-Specific Values

Set your actual values in `all.yml`:

```yaml
# In all.yml
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-actual-email@gmail.com"
configure_security_updates_gmail_password: "your-actual-app-password"
vps_server_ip: "192.168.1.100"
```

The `features.yml` will automatically use these values:

```yaml
# In features.yml (automatically uses values from all.yml)
notifications:
  email:
    gmail_enabled: "{{ configure_security_updates_gmail_enabled | default(false) }}"
    gmail_user: "{{ configure_security_updates_gmail_user | default('') }}"
    gmail_password: "{{ configure_security_updates_gmail_password | default('') }}"

system:
  server:
    ip: "{{ vps_server_ip | default('your-server-ip-or-hostname') }}"
```

## Migration

### From Old System

1. Copy `all.example.yml` to `all.yml` (if not already done)
2. Copy `features.yml` to your inventory
3. Configure the new structure in `features.yml`
4. Set your actual values in `all.yml`
5. The system will automatically use your values from `all.yml`

### Backward Compatibility

The old variable system is still supported, so existing configurations will continue to work.

## Feature Dependencies

### Required Dependencies

- **Reporting** requires **Email notifications**
- **Container security** requires **Docker deployment**
- **Monitoring alerts** require **Email notifications**

### Optional Dependencies

- **Remote logging** can work independently
- **Log download** can work independently
- **Firewall** can work independently

## Validation

The system includes automatic validation to ensure:

- Required dependencies are enabled
- Configuration values are valid
- No conflicting settings

### Validation Examples

```yaml
# This will fail validation - reporting enabled but no email configured
features:
  reporting: true
notifications:
  email:
    enabled: false

# This will pass validation - all dependencies satisfied
features:
  reporting: true
notifications:
  email:
    enabled: true
    gmail_enabled: true
    gmail_user: "{{ configure_security_updates_gmail_user }}"
    gmail_password: "{{ configure_security_updates_gmail_password }}"
```

## Examples

### Minimal Configuration

```yaml
# In features.yml
features:
  security: true
  monitoring: false
  reporting: false
  containers: true
  networking: true
  logging: false

# In all.yml
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-email@gmail.com"
configure_security_updates_gmail_password: "your-app-password"
```

### Full Configuration

```yaml
# In features.yml
features:
  security: true
  monitoring: true
  reporting: true
  containers: true
  networking: true
  logging: true

# In all.yml - configure all your actual values
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-email@gmail.com"
configure_security_updates_gmail_password: "your-app-password"
vps_server_ip: "192.168.1.100"
initial_deployment_user: "ubuntu"
# ... all other environment-specific values
```

## Troubleshooting

### Feature Not Working

1. Check if the master feature toggle is enabled
2. Check if the specific feature is enabled
3. Check if required dependencies are enabled
4. Check the logs for specific error messages
5. Verify that values are properly set in `all.yml`

### Configuration Conflicts

1. Use the validation playbook to check for conflicts
2. Review the variable mapping for correct structure
3. Ensure no duplicate configurations exist
4. Check that `all.yml` contains the required values

### Common Issues

#### Email Notifications Not Working

```yaml
# PROBLEM: Gmail enabled but no password set in all.yml
# In all.yml
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-email@gmail.com"
# Missing: configure_security_updates_gmail_password

# SOLUTION: Add the missing password to all.yml
configure_security_updates_gmail_password: "your-app-password"
```

#### Variable References Not Working

```yaml
# PROBLEM: Variable not found
# In features.yml
notifications:
  email:
    gmail_user: "{{ configure_security_updates_gmail_user }}"

# In all.yml - variable doesn't exist
# Missing: configure_security_updates_gmail_user

# SOLUTION: Add the variable to all.yml or use a default
notifications:
  email:
    gmail_user: "{{ configure_security_updates_gmail_user | default('') }}"
```

#### Invalid Configuration Values

```yaml
# PROBLEM: Invalid port number in all.yml
# In all.yml
configure_remote_logging_port: 99999  # Invalid port

# SOLUTION: Use valid port number
configure_remote_logging_port: 514  # Valid port
```

## Best Practices

### Configuration Management

- Use version control for `features.yml` (behavior configuration)
- Keep `all.yml` out of version control (contains sensitive data)
- Test configurations in a staging environment first
- Document any custom configurations
- Use the validation system before deployment

### Security Considerations

- Never commit `all.yml` to version control (contains passwords, keys)
- Use environment variables for sensitive data when possible
- Regularly rotate passwords and keys
- Use the secure configuration options provided

### Performance Optimization

- Disable unused features to reduce resource usage
- Use the resource limits for monitoring features
- Configure appropriate retention periods for logs and reports
- Monitor system performance after configuration changes

### Variable Management

- Use descriptive variable names in `all.yml`
- Provide sensible defaults in `features.yml`
- Use the `| default()` filter for optional variables
- Keep environment-specific values separate from behavior configuration
