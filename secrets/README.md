# Secrets Directory

This directory contains sensitive configuration files that should NEVER be committed to version control.

## Files

- `vault.yml` - Ansible vault encrypted file containing sensitive data
- `.env` - Environment variables and configuration

## Security

- All files in this directory are ignored by git
- The vault file is encrypted with Ansible Vault
- Never commit unencrypted sensitive data
- Keep backup copies of vault passwords in a secure location

## Usage

### Vault File

```bash
# Encrypting a vault file from vault.unencrypted.yml using the password file
ansible-vault encrypt secrets/vault.unencrypted.yml --output secrets/vault.yml --vault-password-file secrets/.vault_pass

# Edit vault file
ansible-vault edit secrets/vault.yml

# View vault file
ansible-vault view secrets/vault.yml
```

### Environment File

```bash
# Source environment variables
source secrets/.env

# Or use in scripts
export $(cat secrets/.env | xargs)
```

