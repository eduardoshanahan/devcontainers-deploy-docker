# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- **NEW**: Improved inventory structure following Ansible best practices
  - Environment-specific directories (`production/`, `staging/`, `development/`)
  - `all/vault.yml` for encrypted sensitive data
  - Clear separation of concerns and variable precedence
- **NEW**: Comprehensive security measures to prevent confidential data leaks
  - Enhanced `.gitignore` with comprehensive Ansible security patterns
  - Security guide (`SECURITY.md`) with best practices and emergency procedures
  - Automatic protection of all sensitive inventory files

### Changed

- **BREAKING**: Moved `configure_docker_networks_test_mode` from role defaults to environment-specific configuration
- **BREAKING**: Moved `configure_docker_networks_remove_all` from role defaults to environment-specific configuration
- Network security testing now respects the environment-specific Docker test mode setting
- Removed unused `configure_docker_networks_encrypted` configuration
- **BREAKING**: Restructured inventory organization for better maintainability
  - Environment-specific configuration in dedicated directories (`production/main.yml`, `staging/main.yml`, `development/main.yml`)
  - Centralized sensitive data in `all/vault.yml` (encrypted with Ansible Vault)
  - Improved variable precedence and organization
- **BREAKING**: Enhanced security posture with comprehensive `.gitignore` protection
  - All environment-specific files now automatically protected
  - SSH keys, certificates, and sensitive data automatically excluded
  - Secure configuration management with Ansible Vault

### Fixed

- Alpine Docker image no longer persists after full deployment when test mode is disabled
- Container-based network security tests are properly skipped when test mode is disabled
- Eliminated duplicate configuration definitions across multiple files
- Fixed variable resolution issues in network security testing role
- Improved inventory structure for better environment management
- **CRITICAL**: Prevented potential confidential data leaks through comprehensive `.gitignore`
- **CRITICAL**: Protected all sensitive inventory files from accidental commits

### Security

- **NEW**: Comprehensive `.gitignore` protection for all sensitive files
- **NEW**: Security guide with emergency procedures for data leaks
- **NEW**: Ansible Vault integration for sensitive configuration data
- **NEW**: Automatic protection of production, staging, and development configurations
- **NEW**: Guidelines for using Ansible Vault and environment variables

### Technical Details

- Docker networks test mode is now controlled by environment-specific configuration
- Network security role respects the same test mode flag for consistency
- All container creation and network testing tasks properly skip when test mode is disabled
- Configuration follows single source of truth principle
- New inventory structure provides clear separation between environment-specific values and common sensitive data
- Security-first approach with comprehensive protection against data leaks

## [Previous versions...]
