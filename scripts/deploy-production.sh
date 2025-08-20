#!/bin/bash

# Deploy to Production Environment
# This script deploys the complete system to the production environment

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$PROJECT_ROOT/src"

echo "🚀 Starting Production Deployment"
echo "=================================="
echo "Project Root: $PROJECT_ROOT"
echo "Source Dir: $SRC_DIR"
echo ""

# Change to source directory
cd "$SRC_DIR"

# Verify we're in the right place
if [ ! -f "playbooks/full.yml" ]; then
    echo "❌ Error: playbooks/full.yml not found!"
    echo "   Make sure you're running this from the correct directory"
    exit 1
fi

# Verify inventory exists
if [ ! -f "inventory/hosts.yml" ]; then
    echo "❌ Error: inventory/hosts.yml not found!"
    exit 1
fi

echo "📋 Pre-deployment Checks"
echo "========================"
echo "✅ Found playbooks/full.yml"
echo "✅ Found inventory/hosts.yml"
echo ""

echo "🔐 Running Production Deployment (requires vault password)"
echo "=========================================================="

# Run the full deployment with production target
if ansible-playbook -i inventory/hosts.yml --limit production playbooks/full.yml --ask-vault-pass; then
    echo ""
    echo "✅ PRODUCTION DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo "⏰ Completed at: $(date)"
    echo ""
    echo "🔍 Next steps:"
    echo "  1. Verify services are running"
    echo "  2. Check daily email reports"
    echo "  3. Monitor system logs"
else
    echo ""
    echo "❌ PRODUCTION DEPLOYMENT FAILED!"
    echo "⏰ Failed at: $(date)"
    echo ""
    echo "🔍 Troubleshooting steps:"
    echo "  1. Check the error messages above"
    echo "  2. Verify vault password was correct"
    echo "  3. Check network connectivity to server"
    echo "  4. Review inventory configuration"
    exit 1
fi
