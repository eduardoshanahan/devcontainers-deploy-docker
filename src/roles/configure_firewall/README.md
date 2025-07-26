# Configure Firewall Role

This role configures UFW (Uncomplicated Firewall) for a secure Ubuntu server environment with Docker support.

## What it does

- Installs and configures UFW firewall
- Sets default policies (deny incoming, allow outgoing)
- Allows SSH access (port 22)
- Allows HTTP and HTTPS (ports 80, 443)
- Allows Docker internal networks for container communication
- Allows configurable container ports
- Enables UFW and displays status

## Configuration

### Default container ports

The role allows these ports by default:

- 8080 (Web applications)
- 3000 (Node.js applications)
- 9000 (Portainer)

### Customizing container ports

To add or modify container ports, set the `firewall_container_ports` variable:

```yaml
firewall_container_ports:
  - 8080
  - 3000
  - 9000
  - 5432  # PostgreSQL
  - 3306  # MySQL
```

## Docker Compatibility

This role is configured to work with Docker by:

- Allowing Docker's internal networks (172.16.0.0/12, 192.168.0.0/16, 10.0.0.0/8)
- Enabling container-to-container communication
- Allowing external access to container ports

## Security Features

- Denies all incoming traffic by default
- Only allows explicitly configured ports
- Maintains SSH access for server management
- Supports Docker networking requirements
