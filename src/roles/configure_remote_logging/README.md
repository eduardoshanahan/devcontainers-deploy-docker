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
configure_remote_logging_server: "37.228.203.72"  # Your public IP address
configure_remote_logging_protocol: "udp"
configure_remote_logging_port: 514
```

## Usage

```bash
# Deploy remote logging
ansible-playbook playbooks/configure_remote_logging.yml
```

## Local Machine Setup

**📋 Complete setup instructions are available in [LOCAL_SETUP.md](LOCAL_SETUP.md)**

The local machine setup includes:

### Quick Setup (Option 1: Direct Internet Access)

```bash
# Install rsyslog
sudo apt-get install rsyslog

# Configure for remote log reception
sudo nano /etc/rsyslog.conf
```

Add to `/etc/rsyslog.conf`:

```conf
# Load modules for remote reception
module(load="imudp")
module(load="imtcp")

# Listen on port 514
input(type="imudp" port="514")
input(type="imtcp" port="514")

# Create log template
$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
```

```bash
# Create log directory
sudo mkdir -p /var/log/remote
sudo chown syslog:adm /var/log/remote

# Configure firewall
sudo ufw allow 514/udp
sudo ufw allow 514/tcp

# Restart rsyslog
sudo systemctl restart rsyslog
```

### Alternative Options

- **Option 2**: VPN-based setup (more secure)
- **Option 3**: Cloud-based setup (alternative)

See [LOCAL_SETUP.md](LOCAL_SETUP.md) for detailed instructions for all options.

## Files Created

- `/etc/rsyslog.d/remote-forwarding.conf` - Remote forwarding configuration
- `/etc/rsyslog.d/forwarding-rules.conf` - Log forwarding rules

## Troubleshooting

- **Check configuration**: `rsyslogd -N1`
- **View logs**: `tail -f /var/log/syslog`
- **Test connection**: `logger "test message"`
- **Check remote logs**: `tail -f /var/log/remote/`

For comprehensive troubleshooting, see [LOCAL_SETUP.md](LOCAL_SETUP.md).
