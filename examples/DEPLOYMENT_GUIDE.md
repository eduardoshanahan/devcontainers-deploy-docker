# Secure Docker Deployment Guide

This guide shows how to deploy applications using the secure network configuration implemented in this project.

## Prerequisites

1. **Server Setup**: Run the full deployment playbook

   ```bash
   ansible-playbook playbooks/full.yml
   ```

2. **Network Configuration**: Create secure Docker networks

   ```bash
   ansible-playbook playbooks/configure_docker_networks.yml
   ```

3. **Firewall Configuration**: Configure firewall with secure rules

   ```bash
   ansible-playbook playbooks/configure_firewall.yml
   ```

## Network Architecture

### Network Segmentation

The deployment uses three isolated networks:

- **web-network** (172.20.0.0/16): Frontend services, load balancers, web applications
- **db-network** (172.21.0.0/16): Databases, caches, backend services
- **monitoring-network** (172.22.0.0/16): Monitoring, logging, metrics collection

### Security Benefits

- **Isolation**: Services can only communicate within their designated networks
- **Reduced Attack Surface**: No broad network access (172.16.0.0/12, etc.)
- **Controlled Communication**: Only necessary inter-network traffic
- **Audit Trail**: All networks are labeled and tracked

## Deployment Steps

### 1. Prepare Application

Create a `docker-compose.yml` file using the secure network configuration:

```yaml
version: '3.8'

networks:
  web-network:
    external: true
    name: web-network
  db-network:
    external: true
    name: db-network
  monitoring-network:
    external: true
    name: monitoring-network

services:
  # Your services here...
```

### 2. Deploy Application

```bash
# Copy application files to server
scp -r ./your-app/ user@server:/opt/apps/

# SSH to server and deploy
ssh user@server
cd /opt/apps/your-app
docker-compose up -d
```

### 3. Verify Deployment

```bash
# Check network connectivity
docker network ls
docker network inspect web-network
docker network inspect db-network
docker network inspect monitoring-network

# Check firewall rules
sudo ufw status verbose

# Check container connectivity
docker exec -it container_name ping other_container
```

## Security Best Practices

### 1. Network Assignment

- **Web services**: Use `web-network`
- **Databases**: Use `db-network`
- **Monitoring**: Use `monitoring-network`

### 2. Port Exposure

- Only expose necessary ports to the internet
- Use internal communication for inter-service communication
- Configure firewall rules for specific container ports

### 3. Service Communication

- Services on different networks cannot communicate directly
- Use API gateways or load balancers for cross-network communication
- Implement proper authentication for inter-service communication

### 4. Monitoring

- Monitor network traffic using UFW logs
- Set up alerts for unusual network activity
- Regularly review network access patterns

## Troubleshooting

### Common Issues

1. **Container cannot reach other services**
   - Check if services are on the same network
   - Verify network configuration in docker-compose.yml

2. **Firewall blocking traffic**
   - Check UFW status: `sudo ufw status`
   - Verify container ports are allowed in firewall configuration

3. **Network not found**
   - Ensure networks were created: `docker network ls`
   - Recreate networks if needed: `docker network create network-name`

### Debug Commands

```bash
# Check network connectivity
docker network inspect network-name

# Check container network configuration
docker inspect container-name

# Check firewall rules
sudo ufw status numbered

# Check network logs
sudo tail -f /var/log/ufw.log
```

## Example Deployments

See `examples/docker-compose.secure.yml` for a complete example deployment with all security features enabled.
