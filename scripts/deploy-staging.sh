#!/bin/bash

# Deploy to Staging Environment
# This script deploys the complete system to the staging environment

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$PROJECT_ROOT/src"

echo "🧪 Starting Staging Deployment"
echo "==============================="
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

# Verify staging configuration exists
if [ ! -f "inventory/group_vars/staging/main.yml" ]; then
    echo "❌ Error: Staging configuration not found!"
    exit 1
fi

echo "✅ Pre-flight checks passed"
echo ""

# Run pre-flight check
echo "🔍 Running pre-flight checks..."
if ansible-playbook playbooks/preflight_check.yml --limit staging; then
    echo "✅ Pre-flight checks completed successfully"
else
    echo "⚠️  Pre-flight checks had issues, but continuing..."
fi
echo ""

# Show deployment info
echo "🎯 Target: STAGING ENVIRONMENT"
echo "📍 Server: $(grep 'vps_server_ip:' inventory/group_vars/staging/main.yml | awk '{print $2}' | tr -d '"')"
echo "⚠️  Note: Staging uses safer defaults (no clean slate deployments)"
echo ""
read -p "Deploy to STAGING environment? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "🧪 Starting full staging deployment..."
echo "⏰ Started at: $(date)"
echo ""

# Run the deployment
if ansible-playbook playbooks/full.yml --ask-vault-pass --limit staging; then
    echo ""
    echo "✅ STAGING DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo "⏰ Completed at: $(date)"
    echo ""
    echo "🔍 Next steps:"
    echo "  1. Test all functionality in staging"
    echo "  2. Verify configuration changes"
    echo "  3. Run integration tests"
    echo "  4. If all looks good, deploy to production"
else
    echo ""
    echo "❌ STAGING DEPLOYMENT FAILED!"
    echo "⏰ Failed at: $(date)"
    exit 1
fi