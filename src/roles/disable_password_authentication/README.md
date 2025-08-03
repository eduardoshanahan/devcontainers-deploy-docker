# Disable Password Authentication Role

This role disables password authentication for SSH, enforcing key-based authentication only.

## What it does

- Disables password authentication in SSH configuration
- Disables root login via SSH
- Disables empty password authentication
- Configures SSH to use key-based authentication only
- Restarts SSH service to apply changes

## Security Features

- **Key-based authentication only**: No password authentication allowed
- **Root login disabled**: Prevents direct root access via SSH
- **Empty passwords disabled**: Blocks accounts with no passwords
- **SSH service restart**: Ensures changes take effect immediately

## Configuration

The role uses these variables from your inventory:

```yaml
# SSH Configuration
ansible_ssh_common_args: "-o IdentitiesOnly=yes -o PreferredAuthentications=publickey"
ansible_python_interpreter: "/usr/bin/python3.10"
```

## Prerequisites

- SSH keys must be properly configured
- Initial deployment user must have sudo privileges
- SSH service must be running

## Dependencies

- Requires `update_ubuntu` role to be run first
- Requires SSH keys to be properly set up

## Usage

```bash
# Run individually
ansible-playbook playbooks/disable_password_authentication.yml

# Or as part of full deployment
ansible-playbook playbooks/full.yml
```

## Security Considerations

- **Test SSH access** before running this role
- **Ensure SSH keys are working** before disabling passwords
- **Keep backup access** in case of SSH key issues
- **Monitor SSH logs** after implementation

## Troubleshooting

If you lose SSH access:

1. **Check SSH keys**: Verify keys are properly configured
2. **Check SSH logs**: `sudo tail -f /var/log/auth.log`
3. **Temporary password access**: Temporarily re-enable password auth if needed
4. **Console access**: Use server console if available

## Files Modified

- `/etc/ssh/sshd_config` - SSH daemon configuration
- SSH service restarted to apply changes
