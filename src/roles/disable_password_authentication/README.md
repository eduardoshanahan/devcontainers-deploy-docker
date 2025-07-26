# Disable Password Authentication Role

This role secures SSH configuration by disabling password authentication and implementing security best practices.

## What it does

- Disables password authentication (key-based only)
- Disables root login
- Disables empty passwords
- Validates SSH configuration before applying changes
- Restarts SSH service to apply changes

## Security Features

- **Key-based authentication only** - Prevents brute force password attacks
- **Root login disabled** - Prevents direct root access
- **Empty passwords disabled** - Additional security measure
- **Configuration validation** - Ensures SSH config is valid before restart

## Important Notes

**Warning:** Ensure your SSH key authentication is working before running this role. If key authentication fails, you may lose access to the server.

## Configuration

No configuration required - uses secure defaults for SSH hardening.

## Handlers

- `restart ssh` - Restarts SSH service when configuration changes
