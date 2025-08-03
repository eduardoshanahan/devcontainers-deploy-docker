# Project Documentation Index

This directory contains all project documentation organized to mirror the project structure.

## Directory Structure

```text
documentation/
├── README.md                           # Main project overview
├── Improvements.md                     # Security improvements and recommendations
├── LICENSE                            # Project license
├── Security.md                        # Security configuration guide
├── Email setup.md                     # Gmail SMTP setup guide
├── src/
│   ├── roles/
│   │   ├── update_ubuntu/            # Ubuntu update role documentation
│   │   ├── disable_password_authentication/  # SSH security role
│   │   ├── create_deployment_user/   # User creation role
│   │   ├── configure_firewall/       # Firewall configuration role
│   │   ├── configure_docker_networks/ # Docker networks role
│   │   ├── configure_fail2ban/       # Fail2ban role
│   │   ├── configure_monitoring/     # Monitoring role
│   │   ├── configure_log_rotation/   # Log rotation role
│   │   ├── configure_security_updates/ # Security updates role
│   │   ├── deploy_docker/            # Docker deployment role
│   │   └── test_network_security/   # Network security testing role
│   ├── playbooks/
│   │   ├── README.md                 # Playbooks guide
│   │   └── REBOOT_INSTRUCTIONS.md   # Reboot instructions
│   └── inventory/
│       └── group_vars/
│           └── README.md             # Inventory variables guide
├── examples/
│   └── DEPLOYMENT_GUIDE.md          # Deployment guide
├── scripts/
│   └── test_network_security.sh     # Network security test script
└── .devcontainer/
    └── README.md                     # Devcontainer setup guide
```

## Quick Start

1. **Main Documentation**: Start with `README.md` for project overview
2. **Security Setup**: See `Security.md` for security configuration
3. **Email Setup**: See `Email setup.md` for Gmail configuration
4. **Deployment**: See `examples/DEPLOYMENT_GUIDE.md` for deployment instructions

## Role Documentation

Each role has its own documentation explaining:

- What the role does
- Configuration variables
- Usage instructions
- Security features
- Troubleshooting tips

## Configuration

- **Inventory Variables**: See `src/inventory/group_vars/README.md`
- **Playbooks**: See `src/playbooks/README.md`
- **Security**: See `Security.md`

## Additional Resources

- **Improvements**: See `Improvements.md` for security recommendations
- **Examples**: See `examples/` for deployment examples
- **Scripts**: See `scripts/` for utility scripts

## Navigation

All files are symlinked to their original locations, so:

- **Updates are automatic**: Changes to original files are reflected here
- **Easy navigation**: Find documentation by following the project structure
- **Consistent organization**: Documentation mirrors the actual project layout
