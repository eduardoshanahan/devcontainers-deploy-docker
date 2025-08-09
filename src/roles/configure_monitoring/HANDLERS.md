# Monitoring Role Handlers

This document lists all handlers used by the monitoring role and their purposes.

## Required Handlers

### Restart docker

- **Purpose**: Restart Docker daemon after configuration changes
- **Triggered by**: Docker logging configuration changes
- **File**: `handlers/main.yml`
- **Service**: docker

### Restart rsyslog

- **Purpose**: Restart rsyslog after configuration changes
- **Triggered by**: Logging configuration changes
- **File**: `handlers/main.yml`
- **Service**: rsyslog

### Restart auditd

- **Purpose**: Restart auditd after configuration changes
- **Triggered by**: Audit configuration changes
- **File**: `handlers/main.yml`
- **Service**: auditd

### Restart aide

- **Purpose**: Restart AIDE after configuration changes
- **Triggered by**: File integrity monitoring configuration changes
- **File**: `handlers/main.yml`
- **Service**: aide

## Handler Validation

The role includes validation to ensure all required handlers are available before execution.

## Troubleshooting

If you encounter "handler not found" errors:

1. Check that `handlers/main.yml` exists and is properly formatted
2. Verify the handler name matches exactly (case-sensitive)
3. Run with `--flush-cache` to clear Ansible cache
4. Check file permissions on the handlers file
