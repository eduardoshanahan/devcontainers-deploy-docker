# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Centralized Docker network test mode configuration in `features.yml`
- Unified testing behavior across Docker networks and network security roles

### Changed
- **BREAKING**: Moved `configure_docker_networks_test_mode` from role defaults to centralized `features.yml`
- **BREAKING**: Moved `configure_docker_networks_remove_all` from role defaults to centralized `features.yml`
- Network security testing now respects the centralized Docker test mode setting
- Removed unused `configure_docker_networks_encrypted` configuration

### Fixed
- Alpine Docker image no longer persists after full deployment when test mode is disabled
- Container-based network security tests are properly skipped when test mode is disabled
- Eliminated duplicate configuration definitions across multiple files
- Fixed variable resolution issues in network security testing role

### Technical Details
- Docker networks test mode is now controlled by `features.containers.networks.test_mode`
- Network security role respects the same test mode flag for consistency
- All container creation and network testing tasks properly skip when test mode is disabled
- Configuration follows single source of truth principle

## [Previous versions...]
