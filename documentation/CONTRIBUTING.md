# Contributing Guide

## Overview

Thank you for your interest in contributing to this Ansible-based infrastructure automation project! This guide provides comprehensive information on how to contribute effectively, whether you're reporting bugs, suggesting features, or submitting code changes.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Development Environment](#development-environment)
3. [Code Style and Standards](#code-style-and-standards)
4. [Testing Guidelines](#testing-guidelines)
5. [Submitting Changes](#submitting-changes)
6. [Bug Reports](#bug-reports)
7. [Feature Requests](#feature-requests)
8. [Documentation](#documentation)
9. [Security](#security)
10. [Community Guidelines](#community-guidelines)

## Getting Started

### Prerequisites

Before contributing, ensure you have the following:

- **Docker**: For running the development container
- **Git**: For version control
- **VS Code** or **Cursor**: For development (recommended)
- **SSH Keys**: For testing deployments
- **Ubuntu VPS**: For testing deployments (optional)

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:

   ```bash
   git clone https://github.com/your-username/ansible-docker-deployment.git
   cd ansible-docker-deployment
   ```

3. **Add upstream remote**:

   ```bash
   git remote add upstream https://github.com/original-owner/ansible-docker-deployment.git
   ```

### Development Setup

1. **Configure environment**:

   ```bash
   cp .devcontainer/config/.env.example .devcontainer/config/.env
   nano .devcontainer/config/.env
   ```

2. **Launch development environment**:

   ```bash
   chmod +x launch.sh
   ./launch.sh
   ```

3. **Verify setup**:

   ```bash
   cd src
   ansible --version
   ansible-lint --version
   ```

## Development Environment

### DevContainer Features

The development container provides:

- **Ansible 9.2.0** with linting support
- **Docker CLI** tools
- **SSH agent** with key management
- **VS Code extensions** for Ansible, YAML, Docker
- **Custom shell prompt** with project context
- **Environment validation** and error handling

### Environment Variables

Configure your development environment:

```bash
# User configuration
HOST_USERNAME=your_username
HOST_UID=1000
HOST_GID=1000

# Git configuration
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# Editor choice
EDITOR_CHOICE=code  # or 'cursor'

# Container resources
CONTAINER_MEMORY=4g
CONTAINER_CPUS=2
CONTAINER_SHM_SIZE=2g

# Ansible versions
PYTHON_VERSION=3.11
ANSIBLE_VERSION=9.2.0
ANSIBLE_LINT_VERSION=25.1.3
```

### Testing Environment

Set up a testing environment:

1. **Create test server** (Ubuntu 22.04 VPS)
2. **Configure SSH access**:

   ```bash
   ssh-copy-id -i ~/.ssh/your-key user@test-server
   ```

3. **Update inventory**:

   ```bash
   cp src/inventory/group_vars/all.example.yml src/inventory/group_vars/all.yml
   nano src/inventory/group_vars/all.yml
   ```

4. **Test deployment**:

   ```bash
   cd src
   ansible-playbook --config-file ansible.dev.cfg playbooks/full.yml
   ```

## Code Style and Standards

### Ansible Best Practices

#### Playbook Structure

```yaml
---
- name: Descriptive playbook name
  hosts: all
  become: true
  vars:
    # Define variables at playbook level
    variable_name: "value"
  
  pre_tasks:
    - name: Pre-deployment tasks
      # Pre-deployment logic
  
  roles:
    - role_name
  
  tasks:
    - name: Post-deployment tasks
      # Post-deployment logic
  
  handlers:
    - name: Restart service
      # Handler logic
```

#### Role Structure

```text
role_name/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   └── template.j2       # Jinja2 templates
├── vars/
│   └── main.yml          # Role variables
└── README.md             # Role documentation
```

#### Variable Naming

```yaml
# Use descriptive, lowercase names with underscores
role_name_enabled: true
role_name_config_path: "/etc/application/config.yml"
role_name_service_name: "application-service"

# Group related variables
role_name_network:
  subnet: "172.20.0.0/16"
  gateway: "172.20.0.1"
  dns: ["8.8.8.8", "8.8.4.4"]
```

#### Task Structure

```yaml
- name: Descriptive task name
  module_name:
    parameter1: "value1"
    parameter2: "value2"
  register: task_result
  when: condition is met
  failed_when: task_result.rc != 0
  changed_when: task_result.changed
```

### YAML Style Guidelines

#### Indentation

```yaml
# Use 2 spaces for indentation
variable_name:
  nested_value:
    deep_nested: "value"
  list_item:
    - item1
    - item2
```

#### Comments

```yaml
# Use comments to explain complex logic
variable_name: "value"  # Inline comment for simple explanations

# Block comments for complex sections
# This section configures network security
# - Allows specific Docker networks
# - Blocks broad network ranges
network_config:
  allowed_networks:
    - "172.20.0.0/16"
    - "172.21.0.0/16"
```

#### Lists and Dictionaries

```yaml
# Use lists for similar items
ports:
  - 80
  - 443
  - 8080

# Use dictionaries for structured data
network_config:
  name: "web-network"
  subnet: "172.20.0.0/16"
  driver: "bridge"
```

### Documentation Standards

#### Role Documentation

```markdown
# Role Name

## Purpose
Brief description of what this role does.

## Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `role_name_enabled` | `true` | Enable/disable the role |
| `role_name_config` | `{}` | Configuration dictionary |

## Dependencies
- List of required roles or packages

## Example Usage
```yaml
role_name_enabled: true
role_name_config:
  setting1: "value1"
  setting2: "value2"
```

## Tasks

- Task 1: Description
- Task 2: Description

## Playbook Documentation

Playbook Name

## Purpose

Description of what this playbook accomplishes.

## Usage

```bash
ansible-playbook playbooks/playbook_name.yml
```

## Variables

- `variable1`: Description
- `variable2`: Description

## Dependencies

- Required roles or playbooks

## Output

Description of expected results

## Testing Guidelines

### Automated Testing

#### Ansible Lint

```bash
# Lint all playbooks
ansible-lint src/playbooks/

# Lint specific playbook
ansible-lint src/playbooks/full.yml

# Lint with custom rules
ansible-lint --rules-dir custom-rules/ src/playbooks/
```

#### Syntax Checking

```bash
# Check playbook syntax
ansible-playbook --syntax-check src/playbooks/full.yml

# Check all playbooks
for playbook in src/playbooks/*.yml; do
  ansible-playbook --syntax-check "$playbook"
done
```

#### Dry Run Testing

```bash
# Test playbook without changes
ansible-playbook --check src/playbooks/full.yml

# Test with verbose output
ansible-playbook --check -vvv src/playbooks/full.yml
```

### Manual Testing

#### Development Environment Testing

```bash
# Test in development environment
ansible-playbook --config-file ansible.dev.cfg src/playbooks/full.yml

# Test individual components
ansible-playbook --config-file ansible.dev.cfg src/playbooks/update_ubuntu.yml
ansible-playbook --config-file ansible.dev.cfg src/playbooks/deploy_docker.yml
```

#### Production Environment Testing

```bash
# Test in production environment
ansible-playbook --config-file ansible.prod.cfg src/playbooks/full.yml

# Test with specific inventory
ansible-playbook -i test-inventory.yml src/playbooks/full.yml
```

#### Security Testing

```bash
# Test network security
ansible-playbook src/playbooks/test_network_security.yml

# Test firewall configuration
ansible all -m shell -a "sudo ufw status verbose"

# Test SSH security
ansible all -m shell -a "sudo sshd -T | grep -E 'password|permitroot'"
```

### Integration Testing

#### Test Scenarios

1. **Fresh Server Deployment**
   - Deploy to new Ubuntu server
   - Verify all components work
   - Test security configurations

2. **Existing Server Update**
   - Deploy to server with existing configuration
   - Verify no conflicts
   - Test rollback procedures

3. **Multi-Server Deployment**
   - Deploy to multiple servers
   - Test load balancing
   - Verify network isolation

#### Test Checklist

- [ ] All playbooks execute successfully
- [ ] No syntax errors or linting issues
- [ ] Security configurations are applied correctly
- [ ] Docker networks are created and isolated
- [ ] Monitoring and logging work properly
- [ ] Email notifications are sent correctly
- [ ] Backup and recovery procedures work

## Submitting Changes

### Git Workflow

#### Branch Naming

```bash
# Feature branches
git checkout -b feature/add-new-role

# Bug fix branches
git checkout -b fix/ssh-connection-issue

# Documentation branches
git checkout -b docs/update-deployment-guide
```

#### Commit Messages

```bash
# Use conventional commit format
git commit -m "feat: add new monitoring role"

# Types: feat, fix, docs, style, refactor, test, chore
# Scope: role name, playbook name, component
# Description: concise description
```

#### Pull Request Process

1. **Create feature branch** from `main`
2. **Make changes** with proper testing
3. **Update documentation** if needed
4. **Run tests** and fix any issues
5. **Submit pull request** with detailed description

### Pull Request Guidelines

#### Required Information

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Security improvement

## Testing
- [ ] Manual testing completed
- [ ] Automated tests pass
- [ ] Documentation updated

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

#### Review Process

1. **Self-review** your changes
2. **Request review** from maintainers
3. **Address feedback** promptly
4. **Update PR** as needed
5. **Merge** after approval

## Bug Reports

### Bug Report Template

```markdown
## Bug Description
Clear description of the issue

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: Ubuntu 22.04
- Ansible Version: 9.2.0
- Docker Version: 20.10.21
- Python Version: 3.11

## Additional Information
- Error messages
- Log files
- Screenshots
```

### Bug Report Guidelines

- **Be specific** about the issue
- **Include error messages** and logs
- **Provide reproduction steps**
- **Test on clean environment**
- **Check existing issues** first

## Feature Requests

### Feature Request Template

```markdown
## Feature Description
Clear description of the requested feature

## Use Case
Why this feature is needed

## Proposed Solution
How the feature should work

## Alternatives Considered
Other approaches that were considered

## Additional Information
- Related issues
- Implementation suggestions
- Mockups or examples
```

### Feature Request Guidelines

- **Explain the use case** clearly
- **Consider alternatives** first
- **Provide implementation ideas**
- **Check existing features**
- **Be patient** with responses

## Documentation

### Documentation Standards Applied

#### Writing Style

- **Clear and concise** language
- **Step-by-step** instructions
- **Code examples** where helpful
- **Screenshots** for complex procedures
- **Cross-references** to related docs

#### Documentation Structure

```markdown
# Title

## Overview
Brief introduction

## Prerequisites
Requirements and setup

## Procedure
Step-by-step instructions

## Verification
How to verify success

## Troubleshooting
Common issues and solutions

## Related Documentation
Links to related docs
```

#### Code Documentation

```yaml
# Document complex variables
role_name_complex_config:
  # Network configuration for Docker containers
  # - subnet: IP range for the network
  # - gateway: Default gateway for the network
  # - dns: DNS servers for the network
  network:
    subnet: "172.20.0.0/16"
    gateway: "172.20.0.1"
    dns: ["8.8.8.8", "8.8.4.4"]
```

### Documentation Updates

- **Update docs** with code changes
- **Add examples** for new features
- **Fix broken links** and references
- **Review accuracy** regularly
- **Test procedures** before publishing

## Security

### Security Guidelines

#### Code Security

- **Validate all inputs** from users
- **Use secure defaults** for configurations
- **Implement proper error handling**
- **Follow security best practices**
- **Test security configurations**

#### Security Reporting

```markdown
## Security Issue Report

### Issue Description
Description of the security vulnerability

### Impact
Potential impact of the vulnerability

### Steps to Reproduce
Steps to reproduce the issue

### Suggested Fix
Proposed solution (if any)

### Contact Information
How to contact for sensitive issues
```

#### Security Best Practices

- **Report security issues** privately
- **Use secure communication** channels
- **Test security fixes** thoroughly
- **Document security procedures**
- **Follow responsible disclosure**

## Community Guidelines

### Code of Conduct

#### Be Respectful

- **Respect all contributors**
- **Use inclusive language**
- **Be patient with newcomers**
- **Provide constructive feedback**
- **Help others learn**

#### Communication

- **Be clear and concise**
- **Ask questions** when unsure
- **Provide context** for issues
- **Use appropriate channels**
- **Follow project conventions**

#### Collaboration

- **Share knowledge** freely
- **Help review** others' work
- **Mentor new contributors**
- **Celebrate contributions**
- **Build community**

### Getting Help

#### Support Channels

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and discussions
- **Documentation**: For self-help resources
- **Community Chat**: For real-time help

#### Asking Questions

```markdown
## Question Title

### Context
What you're trying to accomplish

### What You've Tried
Steps you've already taken

### Error Messages
Any error messages or logs

### Environment
Your setup and configuration

### Additional Information
Anything else that might be relevant
```

### Recognition

#### Contributor Recognition

- **Contributor list** in README
- **Release notes** for significant contributions
- **Thank you messages** for help
- **Community highlights** for outstanding work

#### Contribution Types

- **Code contributions** (features, bug fixes)
- **Documentation** improvements
- **Testing** and bug reports
- **Community** support and mentoring
- **Security** research and reporting

## Development Workflow

### Daily Workflow

```bash
# Start development session
./launch.sh

# Make changes
cd src
# Edit files...

# Test changes
ansible-lint playbooks/
ansible-playbook --syntax-check playbooks/full.yml

# Commit changes
git add .
git commit -m "feat: add new feature"

# Push to fork
git push origin feature/new-feature
```

### Release Process

1. **Create release branch** from `main`
2. **Update version** and changelog
3. **Test thoroughly** in multiple environments
4. **Create release** on GitHub
5. **Announce** to community

### Maintenance Tasks

- **Regular dependency updates**
- **Security patch reviews**
- **Documentation updates**
- **Community support**
- **Performance monitoring**

This comprehensive contributing guide ensures that all contributors can effectively participate in the project's development while maintaining high standards for code quality, security, and community collaboration.
