# Gmail SMTP Setup for Security Update Notifications

This guide explains how to configure Gmail SMTP for email notifications from security updates.

## Prerequisites

1. **Gmail Account**: You need a Gmail account
2. **App Password**: You need to generate an App Password (not your regular Gmail password)

## Step 1: Generate Gmail App Password

1. Go to your Google Account settings: https://myaccount.google.com/
2. Navigate to **Security** → **2-Step Verification** (enable if not already enabled)
3. Go to **App passwords** (under 2-Step Verification)
4. Select **Mail** as the app and **Other** as the device
5. Click **Generate**
6. Copy the 16-character password (you'll only see it once)

## Step 2: Configure Your Inventory

Update your `src/inventory/group_vars/all.yml` file:

```yaml
# Security Updates Configuration
unattended_upgrades_email: "your-email@gmail.com"
security_updates_email: "your-email@gmail.com"

# Gmail SMTP Configuration
security_updates_gmail_enabled: true
security_updates_gmail_user: "your-gmail@gmail.com"
security_updates_gmail_password: "your-16-character-app-password"
security_updates_gmail_smtp_server: "smtp.gmail.com"
security_updates_gmail_smtp_port: "587"
```

## Step 3: Deploy the Configuration

```bash
cd src
ansible-playbook playbooks/configure_security_updates.yml
```

## Step 4: Test the Configuration

```bash
# Test email notification
sudo /opt/security-updates/security-update-notify.sh "Test Email" "This is a test notification from Gmail SMTP"

# Check logs
sudo tail -f /var/log/security-updates.log
```

## Security Considerations

1. **App Passwords**: Use App Passwords, not your regular Gmail password
2. **Environment Variables**: Consider using Ansible Vault for storing sensitive passwords
3. **Network Security**: Ensure your server can reach Gmail's SMTP servers (ports 587/465)
4. **Logging**: All email attempts are logged to `/var/log/security-updates.log`

## Troubleshooting

### Common Issues

1. **Authentication Failed**:
   - Verify you're using an App Password, not your regular password
   - Ensure 2-Step Verification is enabled

2. **Connection Timeout**:
   - Check if your server can reach `smtp.gmail.com:587`
   - Verify firewall rules allow outbound SMTP traffic

3. **SSL/TLS Issues**:
   - The script uses `smtps://` which requires SSL/TLS
   - Gmail requires SSL/TLS on port 587

### Debug Mode

To debug email issues, you can manually test:

```bash
# Test Gmail SMTP connection
curl --verbose --mail-from "your-email@gmail.com" \
     --mail-rcpt "your-email@gmail.com" \
     --upload-file /tmp/test_email \
     --user "your-email@gmail.com:your-app-password" \
     --ssl-reqd \
     "smtps://smtp.gmail.com:587"
```

## Alternative: Using Ansible Vault

For better security, store your Gmail password in an encrypted file:

```bash
# Create encrypted password file
ansible-vault create gmail_password.yml
```

Add to the file:

```yaml
security_updates_gmail_password: "your-app-password"
```

Then reference it in your playbook:

```yaml
- include_vars: gmail_password.yml
```

Run with:

```bash
ansible-playbook --ask-vault-pass playbooks/configure_security_updates.yml
```

## Summary

I've configured Gmail SMTP support for your security update notifications. Here's what I've added:

### 1. **Gmail SMTP Configuration Variables**

- `security_updates_gmail_enabled`: Enable/disable Gmail SMTP
- `security_updates_gmail_user`: Your Gmail address
- `security_updates_gmail_password`: Your Gmail App Password
- `security_updates_gmail_smtp_server`: Gmail SMTP server (smtp.gmail.com)
- `security_updates_gmail_smtp_port`: SMTP port (587)

### 2. **Enhanced Notification Script**

- Added Gmail SMTP support using curl
- Falls back to system mail if Gmail fails
- Better error handling and logging
- SSL/TLS support for secure connections

### 3. **Updated Dependencies**

- Added `curl` package installation for SMTP functionality

### 4. **Documentation**

- Created comprehensive setup guide
- Security considerations
- Troubleshooting tips

### To Use Gmail SMTP

1. **Generate an App Password** in your Google Account settings
2. **Update your configuration** in `src/inventory/group_vars/all.yml`:

   ```yaml
   security_updates_gmail_enabled: true
   security_updates_gmail_user: "your-email@gmail.com"
   security_updates_gmail_password: "your-16-character-app-password"
   ```

3. **Deploy the configuration**:

   ```bash
   cd src
   ansible-playbook playbooks/configure_security_updates.yml
   ```

The system will now use Gmail SMTP for email notifications while maintaining fallback to system mail utilities if Gmail is not configured or fails.
