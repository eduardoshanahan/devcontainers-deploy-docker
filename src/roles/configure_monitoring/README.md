# Configure Monitoring Role

This role sets up basic system monitoring and health checks for Ubuntu servers.

## What it does

- Installs monitoring tools (htop, iotop, nethogs, ncdu, etc.)
- Creates automated health check scripts
- Configures systemd timers for periodic monitoring
- Monitors system resources (CPU, memory, disk)
- Monitors Docker service and containers
- Monitors fail2ban service
- Logs health status to `/var/log/health-monitor.log`

## Monitoring Tools Installed

- **htop** - Interactive process viewer
- **iotop** - I/O monitoring
- **nethogs** - Network usage monitoring
- **ncdu** - Disk usage analyzer
- **tree** - Directory tree viewer
- **net-tools** - Network utilities
- **procps** - Process utilities

## Health Check Scripts

### System Health Check (`/opt/monitoring/health_check.sh`)

- Monitors CPU usage (threshold: 80%)
- Monitors memory usage (threshold: 90%)
- Monitors disk usage (threshold: 85%)
- Checks Docker service status
- Checks fail2ban service status

### Disk Space Check (`/opt/monitoring/disk_check.sh`)

- Monitors all mounted filesystems
- Alerts when usage exceeds threshold
- Logs warnings to health monitor log

### Docker Health Check (`/opt/monitoring/docker_check.sh`)

- Verifies Docker service is running
- Lists running containers
- Identifies stopped containers
- Logs container status

## Automated Monitoring

- **Frequency**: Every 5 minutes (configurable)
- **Method**: systemd timer
- **Logging**: `/var/log/health-monitor.log`
- **Service**: `health-monitor.timer`

## Configuration

All thresholds are configurable via variables:

- `configure_monitoring_disk_threshold`: 85%
- `configure_monitoring_memory_threshold`: 90%
- `configure_monitoring_cpu_threshold`: 80%
- `configure_monitoring_health_check_interval`: 300 seconds

## Benefits

- **Proactive monitoring** - Detects issues before they become critical
- **Resource tracking** - Monitors system resource usage
- **Service monitoring** - Ensures critical services are running
- **Automated alerts** - Logs warnings when thresholds are exceeded
- **Easy troubleshooting** - Provides tools for system analysis
