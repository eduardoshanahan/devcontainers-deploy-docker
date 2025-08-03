# Configure Security Updates Role

This role configures automatic security updates with email notifications using unattended-upgrades.

## What it does

- Installs unattended-upgrades and curl packages
- Configures automatic security updates
- Sets up email notifications (Gmail SMTP or system mail)
- Configures Slack/Discord webhook notifications
- Creates notification scripts and logging
- Configures log rotation for security update logs

## Features

### Email Notifications

- **Gmail SMTP**: Secure email notifications via Gmail SMTP
- **System Mail**: Fallback to system mail utilities
- **Multiple Recipients**: Support for multiple email addresses
- **Error Handling**: Graceful fallback between notification methods

### Alternative Notifications

- **Slack**: Webhook-based Slack notifications
- **Discord**: Webhook-based Discord notifications
- **Logging**: All notifications are logged to `/var/log/security-updates.log`

### Security Updates Configuration

- **Automatic Updates**: Configures unattended-upgrades for security updates
- **Reboot Control**: Optional automatic reboots after updates
- **Package Blacklist**: Excludes certain packages from automatic updates
- **Error Reporting**: Email notifications for update failures

## Configuration Variables

### Email Configuration

```yaml
# Basic email notification
configure_security_updates_email: "admin@example.com"

# Gmail SMTP configuration
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-email@gmail.com"
configure_security_updates_gmail_password: "your-app-password"
configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
configure_security_updates_gmail_smtp_port: "587"
```

### Alternative Notifications

```yaml
# Slack webhook
configure_security_updates_slack_webhook: "https://hooks.slack.com/services/..."

# Discord webhook
configure_security_updates_discord_webhook: "https://discord.com/api/webhooks/..."
```

### Update Configuration

```yaml
# Enable/disable automatic updates
configure_security_updates_enabled: true

# Automatic reboot settings
configure_security_updates_auto_reboot: false
configure_security_updates_auto_reboot_time: "02:00"

# Email notification settings
configure_security_updates_mail_on_error: true
configure_security_updates_mail_on_reboot: false
```

## Files Created

- `/opt/security-updates/security-update-notify.sh` - Notification script
- `/var/log/security-updates.log` - Notification log file
- `/etc/apt/apt.conf.d/20auto-upgrades` - APT periodic configuration
- `/etc/apt/apt.conf.d/50unattended-upgrades` - Unattended upgrades configuration
- `/etc/logrotate.d/security-updates` - Log rotation configuration

## Usage

### Manual Testing

```bash
# Test email notification
sudo /opt/security-updates/security-update-notify.sh "Test Subject" "Test message"

# Check logs
sudo tail -f /var/log/security-updates.log
```

### Gmail Setup

1. **Generate App Password** in Google Account settings
2. **Configure variables** in your inventory:

   ```yaml
   configure_security_updates_gmail_enabled: true
   configure_security_updates_gmail_user: "your-email@gmail.com"
   configure_security_updates_gmail_password: "your-app-password"
   ```

3. **Deploy the role**:

   ```bash
   ansible-playbook playbooks/configure_security_updates.yml
   ```

## Security Considerations

- **App Passwords**: Use Gmail App Passwords, not regular passwords
- **Network Access**: Ensure server can reach SMTP servers (ports 587/465)
- **Logging**: All notification attempts are logged for audit
- **Fallback**: Multiple notification methods ensure reliability

## Dependencies

- Requires `curl` package for Gmail SMTP functionality
- Requires `mailutils` package for system mail (usually pre-installed)
- Requires `unattended-upgrades` package for automatic updates

## Troubleshooting

### Common Issues

1. **Gmail Authentication Failed**:
   - Verify App Password is correct
   - Ensure 2-Step Verification is enabled

2. **No Notifications Sent**:
   - Check `/var/log/security-updates.log` for errors
   - Verify email/webhook configuration

3. **Updates Not Installing**:
   - Check `/var/log/unattended-upgrades/` for errors
   - Verify package blacklist configuration 