# Security Guide for Inventory Configuration

## ⚠️ CRITICAL SECURITY WARNINGS

This directory contains configuration files that may include sensitive information. Follow these security guidelines strictly to prevent data leaks.

## 🔒 Files That MUST NOT Be Committed

The following files contain sensitive data and are automatically ignored by `.gitignore`:

### Inventory Configuration Files

- `src/inventory/group_vars/all.yml` - Environment-specific values
- `src/inventory/group_vars/production.yml` - Production configuration
- `src/inventory/group_vars/staging.yml` - Staging configuration  
- `src/inventory/group_vars/development.yml` - Development configuration
- `src/inventory/host_vars/*.yml` - Host-specific variables

### SSH and Authentication Files

- `src/inventory/known_hosts` - SSH known hosts
- `src/inventory/known_hosts.template` - SSH template
- Any SSH private keys (`.pem`, `.key`, etc.)

### Ansible Vault Files

- `*.vault` - Encrypted vault files
- `vault.yml` - Main vault file

## ✅ Safe Files to Commit

These files are safe and should be committed:

- `src/inventory/group_vars/base.yml` - Non-confidential defaults
- `src/inventory/group_vars/features.yml` - Feature flags (no secrets)
- `src/inventory/hosts.yml` - Host definitions (no sensitive data)
- `src/inventory/README.md` - Documentation
- `src/inventory/SECURITY.md` - This security guide

## 🛡️ Security Best Practices

### 1. Use Ansible Vault for Secrets

```bash
# Encrypt sensitive files
ansible-vault encrypt src/inventory/group_vars/production.yml

# Edit encrypted files
ansible-vault edit src/inventory/group_vars/production.yml

# Run playbooks with vault
ansible-playbook -i src/inventory playbooks/full.yml --ask-vault-pass
```

### 2. Use Environment Variables

```yaml
# Instead of hardcoding passwords
configure_security_updates_gmail_password: "{{ vault_security_updates_gmail_password }}"
# or
configure_security_updates_gmail_password: "{{ lookup('env', 'GMAIL_PASSWORD') }}"
```

### 3. Use Template Files

Create `.example.yml` files for each environment:

```bash
cp src/inventory/group_vars/production.yml src/inventory/group_vars/production.example.yml
# Remove sensitive data from example file
# Commit the example file
```

### 4. Regular Security Audits

- Review committed files for secrets
- Use `git log -p` to check file history
- Use tools like `truffleHog` to scan for secrets

## 🚨 Emergency Procedures

### If Secrets Are Accidentally Committed

1. **Immediate Actions**:

   ```bash
   # Remove from git history
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch src/inventory/group_vars/production.yml' \
     --prune-empty --tag-name-filter cat -- --all
   
   # Force push to remove from remote
   git push origin --force --all
   ```

2. **Rotate All Secrets**:
   - Change passwords
   - Regenerate SSH keys
   - Update API keys
   - Notify team members

3. **Prevent Future Leaks**:
   - Review `.gitignore` configuration
   - Implement pre-commit hooks
   - Use automated secret scanning

## 📋 Pre-Commit Checklist

Before committing any changes to the inventory:

- [ ] No passwords, API keys, or secrets in plain text
- [ ] No real IP addresses or hostnames
- [ ] No SSH private keys or certificates
- [ ] No database connection strings
- [ ] No email credentials
- [ ] No personal information

## 🔍 Security Scanning Tools

### Automated Secret Detection

```bash
# Install truffleHog
pip install truffleHog

# Scan repository for secrets
truffleHog --regex --entropy=False .

# Install git-secrets
git secrets --install
git secrets --register-aws
```

### Pre-commit Hooks

```bash
# Install pre-commit
pip install pre-commit

# Create .pre-commit-config.yaml
# Add secret scanning rules
```

## 📞 Security Contacts

If you discover a security issue:

1. **Immediate**: Remove sensitive data from commits
2. **Within 1 hour**: Notify the security team
3. **Within 24 hours**: Complete incident report
4. **Within 1 week**: Implement preventive measures

## 📚 Additional Resources

- [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [Git Security Best Practices](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
- [OWASP Security Guidelines](https://owasp.org/www-project-top-ten/)
