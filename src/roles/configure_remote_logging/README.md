# Configure Remote Logging Role

This role configures rsyslog to forward logs to a remote server for centralized log collection.

## What it does

- Installs and configures rsyslog for remote forwarding
- Sets up log forwarding rules for security, system, and Docker logs
- Configures retry mechanisms for reliable log delivery
- Tests the configuration for validity

## Features

### Log Forwarding

- **All logs**: Forward all system logs to remote server
- **Security logs**: SSH, sudo, audit, and AIDE logs
- **System logs**: Systemd and kernel logs
- **Docker logs**: Container and Docker daemon logs

### Reliability Features

- **Retry mechanism**: Automatic retry on connection failure
- **Queue management**: Disk-based queue for log buffering
- **Protocol support**: UDP and TCP forwarding
- **Error handling**: Graceful handling of network issues

## Configuration

### Role Behavior Settings (Role Defaults)

```yaml
# In role defaults/main.yml
configure_remote_logging_enabled: true
configure_remote_logging_protocol: "udp"  # udp or tcp
configure_remote_logging_port: 514
configure_remote_logging_forward_all_logs: true
```

### Environment-Specific Settings (Inventory Variables)

```yaml
# In inventory/group_vars/all.yml
configure_remote_logging_server: "your-local-ip"
configure_remote_logging_protocol: "udp"
configure_remote_logging_port: 514
```

## Usage

```bash
# Deploy remote logging
ansible-playbook playbooks/configure_remote_logging.yml
```

## Local Machine Setup

On your local machine, configure rsyslog to receive logs:

```bash
# Install rsyslog
sudo apt-get install rsyslog

# Edit configuration
sudo nano /etc/rsyslog.conf
```

Add to `/etc/rsyslog.conf`: 