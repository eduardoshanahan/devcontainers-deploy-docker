# Local Machine Setup for Remote Log Collection

This document provides step-by-step instructions to configure your local machine to receive logs from your remote server.

## Prerequisites

- **Local Machine**: Ubuntu/Debian Linux (or similar)
- **Network Access**: Your local machine must be accessible from the internet
- **Router Access**: Ability to configure port forwarding
- **Public IP**: `37.228.203.72` (your current public IP)

## Option 1: Direct Internet Access (Recommended)

### Step 1: Install rsyslog

```bash
# Update package list
sudo apt-get update

# Install rsyslog
sudo apt-get install rsyslog

# Verify installation
rsyslogd -version
```

### Step 2: Configure rsyslog to receive remote logs

```bash
# Backup original configuration
sudo cp /etc/rsyslog.conf /etc/rsyslog.conf.backup

# Edit rsyslog configuration
sudo nano /etc/rsyslog.conf
```

Add these lines to the **end** of `/etc/rsyslog.conf`:

```conf
# ===== REMOTE LOG RECEPTION CONFIGURATION =====

# Load required modules for remote log reception
module(load="imudp")
module(load="imtcp")

# Listen on all interfaces for remote logs
input(type="imudp" port="514")
input(type="imtcp" port="514")

# Create separate log files for remote server
$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"

# Forward all remote logs to template
*.* ?RemoteLogs

# ===== END REMOTE LOG CONFIGURATION =====
```

### Step 3: Create log directory structure

```bash
# Create remote logs directory
sudo mkdir -p /var/log/remote

# Set proper ownership
sudo chown syslog:adm /var/log/remote

# Set proper permissions
sudo chmod 755 /var/log/remote
```

### Step 4: Configure firewall

```bash
# Allow UDP and TCP traffic on port 514
sudo ufw allow 514/udp
sudo ufw allow 514/tcp

# Verify firewall rules
sudo ufw status
```

### Step 5: Restart and enable rsyslog

```bash
# Test configuration
sudo rsyslogd -N1

# Restart rsyslog service
sudo systemctl restart rsyslog

# Enable rsyslog to start on boot
sudo systemctl enable rsyslog

# Check service status
sudo systemctl status rsyslog
```

### Step 6: Configure router port forwarding

**Router Configuration:**

- **External Port**: 514 (UDP/TCP)
- **Internal IP**: Your local machine's IP (find with `ip addr show`)
- **Internal Port**: 514
- **Protocol**: Both UDP and TCP

**Find your local IP:**

```bash
ip addr show | grep "inet " | grep -v 127.0.0.1
```

**Detailed Router Instructions:**

**For TP-Link/Netgear/Asus:**

1. Access router admin panel (usually 192.168.1.1 or 192.168.0.1)
2. Navigate to "Port Forwarding" or "Virtual Server"
3. Add new rule:
   - **Service Name**: rsyslog
   - **External Port**: 514
   - **Internal IP**: [Your local machine IP]
   - **Internal Port**: 514
   - **Protocol**: Both TCP and UDP

**For Linksys:**

1. Go to "Applications & Gaming" → "Port Range Forwarding"
2. Add entry:
   - **Application**: rsyslog
   - **Start**: 514
   - **End**: 514
   - **Protocol**: Both
   - **IP Address**: [Your local machine IP]

**For ISP Routers:**
Contact your ISP to enable port forwarding for port 514

### Step 7: Test the setup

```bash
# Test UDP reception
echo "test message" | nc -u localhost 514

# Test TCP reception
echo "test message" | nc localhost 514

# Check if logs are being written
sudo tail -f /var/log/remote/*/*.log
```

### Step 8: Dynamic IP Address Setup (If Needed)

If your public IP changes frequently:

#### Option A: Dynamic DNS

1. Sign up for a free dynamic DNS service (No-IP, DuckDNS)
2. Install dynamic DNS client:

   ```bash
   sudo apt-get install ddclient
   ```

3. Configure ddclient with your dynamic DNS provider
4. Update inventory with your dynamic DNS hostname

#### Option B: IP Update Script

Create a script to update your server configuration when IP changes:

```bash
#!/bin/bash
NEW_IP=$(curl -s ifconfig.me)
# Update your inventory file with new IP
sed -i "s/configure_remote_logging_server: \".*\"/configure_remote_logging_server: \"$NEW_IP\"/" src/inventory/group_vars/all.yml
```

### Step 9: Using Non-Standard Ports (Optional)

If port 514 is blocked by your ISP, use alternative ports:

**Update local machine:**

```bash
# Use port 10514 instead
sudo ufw allow 10514/udp
sudo ufw allow 10514/tcp
```

**Update rsyslog configuration:**

```conf
input(type="imudp" port="10514")
input(type="imtcp" port="10514")
```

**Update router port forwarding:**

- External Port: 10514
- Internal Port: 10514

**Update server inventory:**

```yaml
configure_remote_logging_port: 10514
```

## Option 2: VPN-Based Setup (More Secure)

### Step 1: Set up WireGuard VPN

```bash
# Install WireGuard
sudo apt-get install wireguard

# Generate keys
wg genkey | sudo tee /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
```

### Step 2: Configure WireGuard server

Create `/etc/wireguard/wg0.conf`:

```ini
[Interface]
PrivateKey = YOUR_PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = SERVER_PUBLIC_KEY
AllowedIPs = 10.0.0.2/32
```

### Step 3: Configure rsyslog for VPN

Update `/etc/rsyslog.conf` to listen on VPN interface:

```conf
# Listen on VPN interface only
input(type="imudp" port="514" address="10.0.0.1")
input(type="imtcp" port="514" address="10.0.0.1")
```

## Option 3: Cloud-Based Setup (Alternative)

### Step 1: Set up cloud server

Use a VPS or cloud instance to receive logs:

```bash
# On cloud server
sudo apt-get install rsyslog
sudo nano /etc/rsyslog.conf
```

### Step 2: Configure cloud rsyslog

Add to `/etc/rsyslog.conf`:

```conf
module(load="imudp")
module(load="imtcp")
input(type="imudp" port="514")
input(type="imtcp" port="514")
$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
```

## Verification and Testing

### Test 1: Local Reception

```bash
# Send test message locally
logger "Test message from local machine"

# Check local logs
tail -f /var/log/syslog
```

### Test 2: Remote Reception

```bash
# From your server, send test message
ssh your-server "logger 'Test message from remote server'"

# Check remote logs
sudo tail -f /var/log/remote/*/*.log
```

### Test 3: Network Connectivity

```bash
# Test UDP connectivity
nc -u -z 37.228.203.72 514

# Test TCP connectivity  
nc -z 37.228.203.72 514
```

## Log File Structure

After setup, logs will be organized as:

```text
/var/log/remote/
├── vps-153d27d0.vps.ovh.net/
│   ├── sshd.log
│   ├── sudo.log
│   ├── docker.log
│   ├── systemd.log
│   └── kernel.log
└── other-hosts/
    └── ...
```

## Monitoring and Maintenance

### Check log reception

```bash
# Monitor incoming logs
sudo tail -f /var/log/remote/*/*.log

# Check rsyslog status
sudo systemctl status rsyslog

# View rsyslog logs
sudo tail -f /var/log/syslog | grep rsyslog
```

### Set Up Log Monitoring

**Create log monitoring script:**

```bash
#!/bin/bash
# /opt/monitor-logs.sh
LOG_DIR="/var/log/remote"
ALERT_EMAIL="your-email@example.com"

# Check if logs are being received
if [ ! -f "$LOG_DIR"/*/*.log ]; then
    echo "No logs received in the last hour" | mail -s "Log Reception Alert" "$ALERT_EMAIL"
fi

# Check log file sizes
find "$LOG_DIR" -name "*.log" -size +100M -exec echo "Large log file detected: {}" \;
```

**Add to crontab:**

```bash
# Check every hour
echo "0 * * * * /opt/monitor-logs.sh" | sudo crontab -
```

### Log rotation

Create `/etc/logrotate.d/remote-logs`:

```conf
/var/log/remote/*/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 syslog adm
}
```

### Log Backup Strategy

**Local Backup:**

```bash
# Create backup script
sudo nano /opt/backup-logs.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/backup/logs"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup
sudo tar -czf "$BACKUP_DIR/logs_$DATE.tar.gz" /var/log/remote/

# Keep only last 30 days
find "$BACKUP_DIR" -name "logs_*.tar.gz" -mtime +30 -delete
```

**Remote Backup (Optional):**

```bash
# Sync to external storage
rsync -avz /var/log/remote/ user@backup-server:/backup/logs/
```

### Performance Optimization

**For High-Volume Logs:**

```bash
# Increase rsyslog queue size
echo '$ActionQueueSize 1000000' >> /etc/rsyslog.conf
echo '$ActionQueueMaxDiskSpace 10g' >> /etc/rsyslog.conf

# Use separate disk for logs
sudo mkdir /mnt/logs
sudo mount /dev/sdb1 /mnt/logs
sudo ln -s /mnt/logs/remote /var/log/remote
```

**Log Rotation Optimization:**

```bash
# Compress old logs immediately
echo 'compress' >> /etc/logrotate.d/remote-logs
echo 'delaycompress' >> /etc/logrotate.d/remote-logs
```

### Security considerations

```bash
# Restrict access to specific IPs (optional)
sudo ufw allow from YOUR_SERVER_IP to any port 514

# Monitor for unauthorized access
sudo tail -f /var/log/auth.log | grep "sshd"
```

### Security Hardening

**Restrict Access by IP:**

```bash
# Only allow your server's IP
sudo ufw delete allow 514/udp
sudo ufw delete allow 514/tcp
sudo ufw allow from YOUR_SERVER_IP to any port 514 proto udp
sudo ufw allow from YOUR_SERVER_IP to any port 514 proto tcp
```

**Enable Log Encryption (Advanced):**

```bash
# Install TLS support
sudo apt-get install rsyslog-gnutls

# Configure TLS in rsyslog
echo 'module(load="gtls")' >> /etc/rsyslog.conf
```

### Integration with Existing Monitoring

**Prometheus/Grafana Integration:**

```bash
# Install node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvf node_exporter-*.tar.gz
sudo cp node_exporter-*/node_exporter /usr/local/bin/

# Create systemd service
sudo nano /etc/systemd/system/node_exporter.service
```

**Add to node_exporter service:**

```ini
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory=/var/lib/node_exporter/textfile_collector

[Install]
WantedBy=multi-user.target
```

## Troubleshooting

### Common Issues

1. **Port not accessible**

   ```bash
   # Check if port is open
   sudo netstat -tulpn | grep 514
   
   # Check firewall
   sudo ufw status
   ```

2. **Logs not being received**

   ```bash
   # Check rsyslog configuration
   sudo rsyslogd -N1
   
   # Check rsyslog logs
   sudo tail -f /var/log/syslog | grep rsyslog
   ```

3. **Permission issues**

   ```bash
   # Fix log directory permissions
   sudo chown -R syslog:adm /var/log/remote
   sudo chmod -R 755 /var/log/remote
   ```

### Debug Commands

```bash
# Test rsyslog configuration
sudo rsyslogd -N1

# Check listening ports
sudo ss -tulpn | grep 514

# Monitor network traffic
sudo tcpdump -i any port 514

# Check log files
ls -la /var/log/remote/
```

## Security Best Practices

1. **Restrict access**: Only allow your server's IP
2. **Use VPN**: Consider WireGuard for encrypted transport
3. **Monitor logs**: Set up alerts for unauthorized access
4. **Regular updates**: Keep rsyslog updated
5. **Backup logs**: Implement log backup strategy

## Next Steps

After completing local setup:

1. **Deploy server configuration**:

   ```bash
   cd src
   ansible-playbook playbooks/configure_remote_logging.yml
   ```

2. **Test end-to-end**:

   ```bash
   # From server
   logger "Test message from server"
   
   # Check local logs
   sudo tail -f /var/log/remote/*/*.log
   ```

3. **Set up monitoring**: Configure alerts for log reception
4. **Implement backup**: Set up log backup to external storage
