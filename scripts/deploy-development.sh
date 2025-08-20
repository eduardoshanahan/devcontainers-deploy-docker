#!/bin/bash

# Deploy to Development Environment
# This script deploys the complete system to the development environment

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$PROJECT_ROOT/src"

echo "🛠️  Starting Development Deployment"
echo "==================================="
echo "Project Root: $PROJECT_ROOT"
echo "Source Dir: $SRC_DIR"
echo ""

# Change to source directory
cd "$SRC_DIR"

# Verify we're in the right place
if [ ! -f "playbooks/full.yml" ]; then
    echo "❌ Error: playbooks/full.yml not found!"
    echo "   Make sure you're running this script from the project root"
    exit 1
fi

# Check if inventory exists
if [ ! -f "inventory/hosts.yml" ]; then
    echo "❌ Error: inventory/hosts.yml not found!"
    exit 1
fi

# Verify development configuration exists
if [ ! -f "inventory/group_vars/development/main.yml" ]; then
    echo "❌ Error: Development configuration not found!"
    exit 1
fi

echo "✅ Pre-flight checks passed"
echo ""

# Show deployment info (no pre-flight check for dev - faster iteration)
echo "🎯 Target: DEVELOPMENT ENVIRONMENT"
echo "📍 Server: $(grep 'vps_server_ip:' inventory/group_vars/development/main.yml | awk '{print $2}' | tr -d '"')"
echo "🛠️  Note: Development uses permissive firewall settings"
echo ""

# No confirmation needed for dev - fast iteration
echo "🛠️  Starting development deployment..."
echo "⏰ Started at: $(date)"
echo ""

# Run the deployment
if ansible-playbook playbooks/full.yml --ask-vault-pass --limit development; then
    echo ""
    echo "✅ DEVELOPMENT DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo "⏰ Completed at: $(date)"
    echo ""
    echo "🔍 Development environment ready for:"
    echo "  1. Code testing and debugging"
    echo "  2. Configuration experiments"
    echo "  3. Feature development"
    echo "  4. Quick iterations"
else
    echo ""
    echo "❌ DEVELOPMENT DEPLOYMENT FAILED!"
    echo "⏰ Failed at: $(date)"
    exit 1
fi