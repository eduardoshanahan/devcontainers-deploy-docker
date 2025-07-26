# Deploy Docker Role

This role installs and configures Docker on Ubuntu systems.

## What it does

- Installs Docker prerequisites (apt-transport-https, ca-certificates, curl, etc.)
- Adds Docker's official GPG key
- Configures Docker repository
- Installs Docker Engine and containerd
- Starts and enables Docker service
- Adds deployment user to docker group
- Displays Docker and Docker Compose versions

## Docker Configuration

- **Repository**: Official Docker repository for Ubuntu
- **Packages**: docker-ce, docker-ce-cli, containerd.io
- **Service**: Enabled and started automatically
- **User permissions**: Deployment user added to docker group

## Version Information

The role displays:

- Docker version after installation
- Docker Compose availability and version
- Service status information

## Docker Compose

- Checks if Docker Compose is available
- Displays version information if present
- Works with both Docker Compose v1 and v2

## Security

- Uses official Docker GPG key for package verification
- Installs from official Docker repository
- Proper user group permissions for Docker access

## Configuration

Docker packages are configurable via `deploy_docker_packages` variable in defaults.
