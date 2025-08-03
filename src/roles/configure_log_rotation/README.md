# Configure Log Rotation Role

This role configures logrotate for automatic log management and disk space optimization.

## What it does

- Installs logrotate package
- Configures system-wide log rotation settings
- Sets up Docker logs rotation with size limits
- Configures fail2ban logs rotation
- Configures SSH logs rotation
- Tests configuration before applying

## Rotation Settings

- **Frequency**: Weekly rotation (configurable)
- **Retention**: 4 rotated logs (configurable)
- **Compression**: Enabled for old logs
- **Date extension**: Enabled for better organization
- **Missing logs**: Ignored (missingok)
- **Empty logs**: Ignored (notifempty)

## Service-Specific Configuration

### Docker Logs

- **Location**: `/var/lib/docker/containers/*/*.log`
- **Size limit**: 100MB before rotation
- **Method**: copytruncate (no service restart needed)

### Fail2ban Logs

- **Location**: `/var/log/fail2ban.log`
- **Post-rotation**: Reloads fail2ban service

### SSH Logs

- **Location**: `/var/log/auth.log`
- **Post-rotation**: Reloads rsyslog service

## Configuration Variables

```yaml
# Log rotation configuration
configure_log_rotation_enabled: true
configure_log_rotation_retention: 4
configure_log_rotation_frequency: "weekly"
configure_log_rotation_compress: true
```

## Configuration Files

- `/etc/logrotate.conf` - Main configuration
- `/etc/logrotate.d/docker` - Docker logs
- `/etc/logrotate.d/fail2ban` - Fail2ban logs
- `/etc/logrotate.d/ssh` - SSH logs

## Benefits

- **Disk space management** - Prevents log files from consuming all disk space
- **Performance** - Smaller log files improve system performance
- **Organization** - Date-stamped rotated logs for better tracking
- **Service compatibility** - Proper service reloads after rotation

## Usage

```bash
# Run individually
ansible-playbook playbooks/configure_log_rotation.yml

# Or as part of full deployment
ansible-playbook playbooks/full.yml
```

## Testing

Test log rotation configuration:

```bash
# Test configuration
sudo logrotate -d /etc/logrotate.conf

# Force rotation
sudo logrotate -f /etc/logrotate.d/docker
```

## Monitoring

- **Check log sizes**: `du -sh /var/log/*`
- **Monitor rotation**: `tail -f /var/log/logrotate`
- **Verify retention**: `ls -la /var/log/*.log.*`

## Troubleshooting

- **Configuration errors**: Check `/var/log/logrotate`
- **Permission issues**: Verify log file permissions
- **Service reloads**: Check if services restart properly
- **Disk space**: Monitor log directory sizes
