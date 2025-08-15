# Inventory Structure

This directory contains the Ansible inventory configuration organized following best practices.

## File Structure

```text
src/inventory/
├── hosts.yml                    # Host definitions and group memberships
├── group_vars/
│   ├── base.yml                # Non-confidential defaults for all environments
│   ├── all.yml                 # Common overrides for all environments
│   ├── features.yml            # Feature flags and behavior configuration
│   ├── production.yml          # Production environment overrides
│   ├── staging.yml             # Staging environment overrides
│   └── development.yml         # Development environment overrides
├── host_vars/
│   └── vps.yml                 # Host-specific variables
└── README.md                   # This file
```

## Variable Precedence (from lowest to highest)

1. **Role defaults** (`src/roles/[role]/defaults/main.yml`)
2. **Base configuration** (`base.yml`) - Non-confidential defaults
3. **Common overrides** (`all.yml`) - Applies to all environments
4. **Environment-specific** (`production.yml`, `staging.yml`, `development.yml`)
5. **Host-specific** (`host_vars/vps.yml`)
6. **Playbook variables** (defined in playbook)
7. **Extra variables** (`-e` command line)

## Environment Configuration

### Production (`production.yml`)

- Contains production-specific values
- Sensitive data should use vault variables
- Test networks enabled for current testing phase

### Staging (`staging.yml`)

- Mirrors production configuration
- Uses test data instead of production data
- More restrictive security settings

### Development (`development.yml`)

- Safe defaults for development
- Disabled security features
- More permissive firewall settings

## Usage

### Deploy to Production

```bash
ansible-playbook -i src/inventory playbooks/full.yml
```

### Deploy to Staging

```bash
ansible-playbook -i src/inventory playbooks/full.yml --limit staging
```

### Deploy to Development

```bash
ansible-playbook -i src/inventory playbooks/full.yml --limit development
```

## Security Notes

- Sensitive data (passwords, API keys) should be stored in Ansible Vault
- Use environment variables for sensitive data when possible
- Never commit sensitive data to version control
- Review `production.yml` for any hardcoded sensitive values

## Migration from Old Structure

The old structure had:

- `defaults.yml` → Now `base.yml`
- `all.yml` → Split into `base.yml`, `all.yml`, and environment-specific files
- `features.yml` → Unchanged (already following best practices)

## Adding New Variables

1. **Non-confidential defaults**: Add to `base.yml`
2. **Common overrides**: Add to `all.yml`
3. **Environment-specific**: Add to appropriate environment file
4. **Host-specific**: Add to `host_vars/vps.yml`
5. **Feature flags**: Add to `features.yml`
