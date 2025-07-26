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
