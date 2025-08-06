# Docker Network Ranges

## Overview

This document describes the Docker network ranges used in this project and provides guidance for other projects that need to create additional networks.

## Currently Allowed Ranges

| Range | Purpose | Status |
|-------|---------|--------|
| `172.20.0.0/16` | Web applications network | Reserved for testing |
| `172.21.0.0/16` | Database network | Reserved for testing |
| `172.22.0.0/16` | Monitoring network | Reserved for testing |

## Available Ranges for New Projects

| Range | Status | Recommended Use |
|-------|--------|-----------------|
| `172.23.0.0/16` | Available | API services |
| `172.24.0.0/16` | Available | Cache services |
| `172.25.0.0/16` | Available | Microservices |
| `172.26.0.0/16` | Available | Development |
| `172.27.0.0/16` | Available | Staging |
| `172.28.0.0/16` | Available | Production |
| `172.29.0.0/16` | Available | Backup services |
| `172.30.0.0/16` | Available | Monitoring |
| `172.31.0.0/16` | Available | Logging |

## Usage Instructions

### For Other Projects

1. **Check current firewall rules:**

   ```bash
   sudo ufw status | grep "172\."
   ```

2. **Choose an available range** from the table above

3. **Create your Docker network:**

   ```bash
   docker network create --subnet=172.25.0.0/16 my-project-network
   ```

4. **Add firewall rule:**

   ```bash
   sudo ufw allow from 172.25.0.0/16
   ```

5. **Verify the rule was added:**

   ```bash
   sudo ufw status verbose
   ```

### Example Workflow

```bash
# 1. Check current rules
sudo ufw status | grep "172\."

# 2. Create network for your project
docker network create --subnet=172.25.0.0/16 my-app-network

# 3. Add firewall permission
sudo ufw allow from 172.25.0.0/16

# 4. Verify
sudo ufw status verbose

# 5. Use in docker-compose.yml
networks:
  my-app-network:
    external: true
```

## Network Management Commands

### Check Current Networks

```bash
# List all Docker networks
docker network ls

# Show network details
docker network inspect network-name
```

### Check Firewall Rules

```bash
# Show all UFW rules
sudo ufw status verbose

# Show only Docker network rules
sudo ufw status | grep "172\."
```

### Remove Networks (if needed)

```bash
# Remove specific network
docker network rm network-name

# Remove firewall rule
sudo ufw delete allow from 172.25.0.0/16
```

## Best Practices

1. **Coordinate ranges** - Check with other projects before using a range
2. **Document usage** - Update this document when using a range
3. **Clean up** - Remove networks and firewall rules when no longer needed
4. **Test connectivity** - Verify containers can communicate after setup

## Troubleshooting

### Network Creation Fails

- Check if range is already in use: `docker network ls`
- Verify Docker daemon is running: `sudo systemctl status docker`

### Firewall Rule Issues

- Check UFW status: `sudo ufw status`
- Verify rule syntax: `sudo ufw allow from RANGE`

### Container Communication Issues

- Check network assignment: `docker inspect container-name`
- Verify firewall rules: `sudo ufw status verbose`
- Test connectivity: `docker exec container-name ping 8.8.8.8`
