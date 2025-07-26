# Configure Fail2ban Role

This role configures fail2ban for SSH protection against brute force attacks.

## What it does

- Installs fail2ban package
- Configures fail2ban main settings
- Sets up SSH jail for protection
- Enables and starts fail2ban service
- Displays service status and configuration

## Security Configuration

- **Ban time**: 1 hour (3600 seconds)
- **Find time**: 10 minutes (600 seconds)
- **Max retry**: 3 failed attempts
- **Ignore IPs**: 127.0.0.1/8 and ::1 (localhost)
- **Protected service**: SSH (port 22)

## Protection Features

- **Brute force protection** - Bans IPs after 3 failed SSH attempts
- **Automatic unbanning** - IPs are unbanned after 1 hour
- **Localhost protection** - Ignores localhost connections
- **Service monitoring** - Monitors SSH authentication logs

## Configuration Files

- `/etc/fail2ban/jail.local` - Main configuration
- `/etc/fail2ban/jail.d/sshd.local` - SSH-specific configuration

## Monitoring

- Service status displayed after configuration
- Logs available at `/var/log/fail2ban.log`
- Banned IPs can be checked with `fail2ban-client banned`

## Handlers

- `restart fail2ban` - Restarts fail2ban service when configuration changes
