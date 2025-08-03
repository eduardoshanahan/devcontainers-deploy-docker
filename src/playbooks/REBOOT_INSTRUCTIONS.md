# Server Reboot Instructions

This document explains how to safely reboot your server using the Ansible playbook.

## Overview

The `reboot_server.yml` playbook provides a safe way to reboot your server by:

- Checking if a reboot is actually required
- Only rebooting when necessary
- Providing proper timeouts and delays
- Ensuring the server comes back online

## When to Reboot

A reboot is typically required after:

- Kernel updates
- System library updates
- Security patches that affect running processes
- Major system updates

## Prerequisites

1. **SSH Access**: Ensure you can SSH into your server
2. **Ansible Setup**: Make sure your Ansible environment is configured
3. **Service Backup**: Consider backing up critical data before rebooting

## Usage

### 1. Check if Reboot is Required (Recommended First Step)

```bash
# SSH into your server and check manually
ssh ubuntu@vps-153d27d0.vps.ovh.net
sudo needrestart -b

# Or check the reboot flag
sudo cat /var/run/reboot-required
```

### 2. Run the Reboot Playbook

```bash
# Navigate to the src directory
cd src

# Run the reboot playbook
ansible-playbook playbooks/reboot_server.yml
```

### 3. Monitor the Reboot Process

The playbook will:

- Check if `/var/run/reboot-required` exists
- Only reboot if required
- Wait up to 300 seconds for the server to come back online
- Test connectivity after reboot

## Playbook Details

### Configuration Options

```yaml
# Timeout settings
connect_timeout: 5        # Time to wait for SSH connection
reboot_timeout: 300       # Maximum time to wait for reboot (5 minutes)
pre_reboot_delay: 0       # Delay before reboot
post_reboot_delay: 30     # Delay after reboot before testing
test_command: whoami      # Command to test if server is back online
```

### What the Playbook Does

1. **Checks for reboot requirement**: Looks for `/var/run/reboot-required` file
2. **Conditional reboot**: Only reboots if the file exists
3. **Safe reboot**: Uses Ansible's built-in reboot module
4. **Verification**: Tests connectivity after reboot
5. **Logging**: Provides detailed output of the process

## Alternative Methods

### Manual Reboot (SSH)

```bash
# SSH into server
ssh ubuntu@vps-153d27d0.vps.ovh.net

# Check what needs reboot
sudo needrestart -b

# Reboot manually
sudo reboot
```

### Scheduled Reboot

```bash
# Schedule reboot for 2 AM
sudo shutdown -r 02:00

# Cancel scheduled reboot
sudo shutdown -c
```

### Force Reboot (Use with Caution)

```bash
# Force reboot even if not required
cd src
ansible-playbook playbooks/reboot_server.yml -e "force_reboot=true"
```

## Safety Considerations

### Before Reboot

1. **Check running services**: Ensure no critical processes are running
2. **Backup data**: Consider backing up important data
3. **Notify users**: If this is a production server, notify users
4. **Check dependencies**: Ensure your services will restart properly

### After Reboot

1. **Verify services**: Check that all services are running
2. **Test functionality**: Test critical applications
3. **Check logs**: Review system logs for any issues
4. **Monitor performance**: Ensure system performance is normal

## Troubleshooting

### Common Issues

1. **Playbook hangs**: The server might be taking longer to reboot

   ```bash
   # Check server status
   ping vps-153d27d0.vps.ovh.net
   ```

2. **SSH connection fails**: Wait a few minutes and try again

   ```bash
   ssh ubuntu@vps-153d27d0.vps.ovh.net
   ```

3. **Services not starting**: Check service status

   ```bash
   sudo systemctl status docker
   sudo systemctl status nginx  # if applicable
   ```

### Manual Recovery

If the playbook fails:

```bash
# SSH into server
ssh ubuntu@vps-153d27d0.vps.ovh.net

# Check system status
sudo systemctl status

# Check for errors
sudo journalctl -xe

# Manual reboot if needed
sudo reboot
```

## Monitoring

### Check Reboot Status

```bash
# Check if reboot is required
sudo cat /var/run/reboot-required

# Check which packages require reboot
sudo cat /var/run/reboot-required.pkgs

# Check system uptime
uptime
```

### Log Files

```bash
# Check Ansible logs
tail -f /var/log/ansible.log

# Check system logs
sudo journalctl -f

# Check unattended-upgrades logs
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log
```

## Best Practices

1. **Schedule during maintenance windows**: Reboot during low-traffic periods
2. **Test in staging first**: If possible, test the reboot process on a staging server
3. **Have a rollback plan**: Know how to restore services if needed
4. **Monitor after reboot**: Keep an eye on system performance and logs
5. **Document the process**: Keep records of when and why reboots were performed

## Emergency Procedures

If the server doesn't come back online:

1. **Wait 5-10 minutes**: Sometimes servers take time to fully boot
2. **Check OVH control panel**: Verify the server is running
3. **Contact support**: If the server is completely unresponsive
4. **Check network**: Ensure network connectivity is restored

## Summary

The reboot playbook provides a safe, automated way to reboot your server when required. It includes proper checks, timeouts, and verification to ensure the process is reliable and safe for production use.