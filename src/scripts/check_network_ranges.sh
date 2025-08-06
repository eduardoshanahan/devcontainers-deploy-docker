#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Docker Network Range Checker ===${NC}"
echo ""

# Check current firewall rules
echo -e "${YELLOW}Current Firewall Rules for Docker Networks:${NC}"
if sudo ufw status | grep -q "172\."; then
    sudo ufw status | grep "172\." | while read line; do
        echo -e "${GREEN}✓ $line${NC}"
    done
else
    echo -e "${RED}✗ No Docker network firewall rules found${NC}"
fi

echo ""
echo -e "${YELLOW}Available Ranges for New Projects:${NC}"

# Define available ranges
declare -a ranges=(
    "172.23.0.0/16"
    "172.24.0.0/16"
    "172.25.0.0/16"
    "172.26.0.0/16"
    "172.27.0.0/16"
    "172.28.0.0/16"
    "172.29.0.0/16"
    "172.30.0.0/16"
    "172.31.0.0/16"
)

# Check which ranges are available
for range in "${ranges[@]}"; do
    if sudo ufw status | grep -q "$range"; then
        echo -e "${RED}✗ $range - IN USE${NC}"
    else
        echo -e "${GREEN}✓ $range - AVAILABLE${NC}"
    fi
done

echo ""
echo -e "${YELLOW}Usage Instructions:${NC}"
echo "1. Choose an available range from above"
echo "2. Create network: docker network create --subnet=RANGE my-network"
echo "3. Add firewall rule: sudo ufw allow from RANGE"
echo "4. Verify: sudo ufw status verbose"
echo ""
echo -e "${BLUE}For more information, see: documentation/DOCKER_NETWORKS.md${NC}" 