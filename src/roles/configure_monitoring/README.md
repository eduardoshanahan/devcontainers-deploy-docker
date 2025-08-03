# Configure Monitoring Role

This role sets up system monitoring and health checks for the server.

## What it does

- Installs monitoring tools and utilities
- Configures system health checks
- Sets up monitoring scripts and cron jobs
- Configures log monitoring and alerting
- Creates monitoring directories and files

## Monitoring Features

- **System health checks**: CPU, memory, disk usage monitoring
- **Service monitoring**: Docker, SSH, firewall status checks
- **Log monitoring**: System and application log monitoring
- **Alerting**: Email notifications for critical issues
- **Performance tracking**: Resource usage monitoring

## Installed Tools

- **htop**: Interactive process viewer
- **iotop**: I/O monitoring
- **ncdu**: Disk usage analyzer
- **logwatch**: Log analysis and reporting
- **fail2ban**: Intrusion prevention (if not already installed)

## Configuration

The role uses these variables from your inventory:

```yaml
# Monitoring configuration
configure_monitoring_enabled: true
configure_monitoring_email: "admin@example.com"
configure_monitoring_check_interval: "5m"
```

## Monitoring Scripts

- **System health check**: `/opt/monitoring/health-check.sh`
- **Resource monitoring**: `/opt/monitoring/resource-monitor.sh`
- **Service status check**: `/opt/monitoring/service-check.sh`

## Cron Jobs

- **Daily health report**: Sent via email
- **Resource monitoring**: Every 5 minutes
- **Service status check**: Every 10 minutes
- **Log analysis**: Daily summary

## Usage

```bash
# Run individually
ansible-playbook playbooks/configure_monitoring.yml

# Or as part of full deployment
ansible-playbook playbooks/full.yml
```

## Monitoring Dashboard

Access monitoring information:

```bash
# Check system health
sudo /opt/monitoring/health-check.sh

# View resource usage
sudo /opt/monitoring/resource-monitor.sh

# Check service status
sudo /opt/monitoring/service-check.sh
```

## Alerting

- **Email notifications**: For critical system issues
- **Log monitoring**: For security and performance issues
- **Service alerts**: For service failures

## Files Created

- `/opt/monitoring/` - Monitoring scripts directory
- `/var/log/monitoring/` - Monitoring logs
- `/etc/cron.d/monitoring` - Cron jobs
- `/etc/logrotate.d/monitoring` - Log rotation

## Troubleshooting

- **Check monitoring logs**: `tail -f /var/log/monitoring/`
- **Verify cron jobs**: `crontab -l`
- **Test email alerts**: Check email configuration
- **Service status**: `systemctl status monitoring`
