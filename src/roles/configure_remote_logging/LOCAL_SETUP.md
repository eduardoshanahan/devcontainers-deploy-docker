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

### Step 7: Test the setup

```bash
# Test UDP reception
echo "test message" | nc -u localhost 514

# Test TCP reception
echo "test message" | nc localhost 514

# Check if logs are being written
sudo tail -f /var/log/remote/*/*.log
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

### Security considerations

```bash
# Restrict access to specific IPs (optional)
sudo ufw allow from YOUR_SERVER_IP to any port 514

# Monitor for unauthorized access
sudo tail -f /var/log/auth.log | grep "sshd"
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
