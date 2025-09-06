# Configure Reporting Role

This role configures comprehensive system reporting with automated email delivery.

## What it does

- Installs reporting dependencies (jq, curl, bc, mailutils)
- Creates reporting directory structure
- Configures automated report generation scripts
- Sets up cron jobs for scheduled reports
- Configures email delivery using existing Gmail SMTP infrastructure
- Implements report cleanup and retention policies

## Features

### Report Types

- **Daily Reports**: System health, security events, and resource usage
- **Weekly Reports**: Extended analysis with trends and statistics
- **Monthly Reports**: Comprehensive system analysis with long-term trends

### Email Integration

- **Gmail SMTP**: Secure email delivery via Gmail SMTP
- **System Mail**: Fallback to system mail utilities
- **HTML Reports**: Beautiful, formatted HTML reports
- **Multiple Recipients**: Support for multiple email addresses

### Report Content

- **System Information**: Hostname, OS, kernel, uptime
- **Resource Usage**: CPU, memory, disk usage
- **Docker Status**: Container counts, image information
- **Security Events**: Failed logins, banned IPs, alerts
- **Recent Alerts**: Last 24 hours of system alerts
- **Trend Analysis**: Weekly and monthly statistics

### Scheduling

- **Daily Reports**: 6:00 AM daily
- **Weekly Reports**: Sunday 7:00 AM
- **Monthly Reports**: 1st of month at 8:00 AM
- **Configurable**: All schedules can be customized

## Configuration

### Role Behavior Settings (Role Defaults)

```yaml
# In role defaults/main.yml
configure_reporting_enabled: true
configure_reporting_daily_enabled: true
configure_reporting_weekly_enabled: true
configure_reporting_monthly_enabled: true
```

### Environment-Specific Settings (Inventory Variables)

```yaml
# In inventory/group_vars/all.yml
configure_reporting_email: "your-email@gmail.com"
configure_reporting_gmail_enabled: true
configure_reporting_gmail_user: "your-gmail@gmail.com"
configure_reporting_gmail_password: "your-app-password"
```

## Files Created

- `/opt/reports/` - Report storage directory
- `/opt/reports/generate-*-report.sh` - Report generation scripts
- `/opt/reports/email-report.sh` - Email delivery script
- `/opt/reports/cleanup-reports.sh` - Cleanup script
- `/var/log/reporting/` - Reporting logs
- `/etc/cron.d/reporting` - Cron jobs

## Usage

### Manual Report Generation

```bash
# Generate daily report
sudo /opt/reports/generate-daily-report.sh

# Generate weekly report
sudo /opt/reports/generate-weekly-report.sh

# Generate monthly report
sudo /opt/reports/generate-monthly-report.sh

# Generate comprehensive report
sudo /opt/reports/generate-comprehensive-report.sh daily
```

### Email Testing

```bash
# Test email delivery
sudo /opt/reports/email-report.sh daily /path/to/report.html
```

### Log Monitoring

```bash
# Check reporting logs
sudo tail -f /var/log/reporting/report-generation.log

# Check email logs
sudo tail -f /var/log/reporting/email-reports.log
```

## Report Retention

- **Daily Reports**: 7 days (configurable)
- **Weekly Reports**: 30 days (configurable)
- **Monthly Reports**: 90 days (configurable)
- **Log Files**: 30 days

## Security Features

- **Secure Email**: SSL/TLS encryption for all emails
- **App Password**: Gmail App Password authentication
- **Log Rotation**: Automatic log cleanup
- **Access Control**: Root-only access to reporting scripts

## Dependencies

- Requires existing email configuration from `configure_security_updates` role
- Requires `jq`, `curl`, `bc`, `mailutils` packages
- Uses existing Gmail SMTP infrastructure

## Troubleshooting

### Common Issues

1. **Reports Not Generated**:
   - Check cron jobs: `crontab -l`
   - Verify script permissions: `ls -la /opt/reports/`
   - Check logs: `tail -f /var/log/reporting/report-generation.log`

2. **Emails Not Sent**:
   - Verify Gmail configuration
   - Check email logs: `tail -f /var/log/reporting/email-reports.log`
   - Test with manual email script

3. **Permission Issues**:
   - Ensure scripts are executable: `chmod +x /opt/reports/*.sh`
   - Check directory permissions: `ls -la /opt/reports/`

### Manual Testing

```bash
# Test report generation
sudo /opt/reports/generate-comprehensive-report.sh daily

# Test email delivery
sudo /opt/reports/email-report.sh daily /opt/reports/daily_report_*.html

# Check for errors
sudo grep ERROR /var/log/reporting/*.log
```

## Integration

This role integrates with existing infrastructure:

- **Email System**: Uses `configure_security_updates` email configuration
- **Monitoring**: Leverages existing monitoring data
- **Logging**: Integrates with existing log collection
- **Security**: Uses existing security event data

## Performance

- **Lightweight**: Optimized for 2GB RAM VPS
- **Efficient**: Minimal resource usage
- **Fast**: Quick report generation
- **Scheduled**: Non-intrusive background operation
