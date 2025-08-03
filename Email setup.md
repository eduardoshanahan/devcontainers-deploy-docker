# Gmail SMTP Setup for Security Update Notifications

This guide explains how to configure Gmail SMTP for email notifications from security updates.

## Prerequisites

1. **Gmail Account**: You need a Gmail account
2. **App Password**: You need to generate an App Password (not your regular Gmail password)

## Step 1: Generate Gmail App Password

1. Go to your Google Account settings: <https://myaccount.google.com/>
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
security_updates_gmail_smtp_port: "465"  # Use port 465 for SMTPS

# Additional variables for the notification script
configure_security_updates_email: "your-email@gmail.com"
configure_security_updates_gmail_enabled: true
configure_security_updates_gmail_user: "your-gmail@gmail.com"
configure_security_updates_gmail_password: "your-16-character-app-password"
configure_security_updates_gmail_smtp_server: "smtp.gmail.com"
configure_security_updates_gmail_smtp_port: "465"  # Use port 465 for SMTPS
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
3. **Network Security**: Ensure your server can reach Gmail's SMTP servers (ports 465/587)
4. **Logging**: All email attempts are logged to `/var/log/security-updates.log`

## Troubleshooting

### Common Issues

1. **Authentication Failed**:
   - Verify you're using an App Password, not your regular password
   - Ensure 2-Step Verification is enabled

2. **Connection Timeout**:
   - Check if your server can reach `smtp.gmail.com:465`
   - Verify firewall rules allow outbound SMTP traffic

3. **SSL/TLS Issues**:
   - Use port 465 (SMTPS) instead of port 587 (STARTTLS)
   - Gmail requires SSL/TLS on both ports

### Debug Mode

To debug email issues, you can manually test:

```bash
# Test Gmail SMTP connection with port 465 (SMTPS)
curl --verbose --mail-from "your-email@gmail.com" \
     --mail-rcpt "your-email@gmail.com" \
     --upload-file <(echo -e "Subject: Test\n\nThis is a test email") \
     --user "your-email@gmail.com:your-app-password" \
     --ssl-reqd \
     "smtps://smtp.gmail.com:465"
```

## Alternative: Using Ansible Vault

For better security, store your Gmail password in an encrypted file:

```bash
# Create encrypted password file
ansible-vault create gmail_password.yml
```

Add to the file:

```yaml
configure_security_updates_gmail_password: "your-app-password"
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

- `configure_security_updates_gmail_enabled`: Enable/disable Gmail SMTP
- `configure_security_updates_gmail_user`: Your Gmail address
- `configure_security_updates_gmail_password`: Your Gmail App Password
- `configure_security_updates_gmail_smtp_server`: Gmail SMTP server
- `configure_security_updates_gmail_smtp_port`: Port 465 for SMTPS

### 2. **Enhanced Notification Script**

- **Gmail SMTP Support**: Direct Gmail SMTP integration
- **Fallback to System Mail**: Automatic fallback if Gmail fails
- **SSL/TLS Security**: Secure email transmission
- **Error Handling**: Comprehensive error logging and recovery

### 3. **Security Features**

- **App Password Authentication**: Secure Gmail authentication
- **Encrypted Transmission**: SSL/TLS encryption for all emails
- **Logging**: Complete audit trail of email notifications
- **Fallback System**: Reliable delivery via system mail

### 4. **Configuration Options**

- **Port 465 (SMTPS)**: Recommended for better compatibility
- **App Password**: More secure than regular passwords
- **Ansible Vault Support**: Encrypted password storage
- **Environment Variables**: Flexible configuration options

## Next Steps

1. **Test the Configuration**: Run the test command to verify email delivery
2. **Monitor Logs**: Check `/var/log/security-updates.log` for email activity
3. **Customize Notifications**: Adjust email content and recipients as needed
4. **Security Review**: Consider using Ansible Vault for production deployments

## Support

If you encounter issues:

1. **Check the logs**: `sudo tail -f /var/log/security-updates.log`
2. **Test manually**: Use the debug curl command provided
3. **Verify Gmail settings**: Ensure 2-Step Verification and App Passwords are enabled
4. **Check network connectivity**: Ensure your server can reach Gmail SMTP servers

The Gmail SMTP configuration is now complete and ready for production use!
