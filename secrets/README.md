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

## Migration from Old Structure

This directory replaces the old vault structure:

- Old: `src/inventory/group_vars/all/vault.yml`
- New: `secrets/vault.yml`

Update your ansible.cfg and playbooks to reference the new location.
