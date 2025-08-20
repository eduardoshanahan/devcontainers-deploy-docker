#!/bin/bash

# Deploy to All Environments (Sequential)
# This script deploys to development, then staging, then production

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🌍 Deploy to All Environments"
echo "============================="
echo ""
echo "This will deploy to environments in this order:"
echo "  1. 🛠️  Development"
echo "  2. 🧪 Staging" 
echo "  3. 🚀 Production"
echo ""
echo "⚠️  WARNING: This will deploy to PRODUCTION!"
echo ""
read -p "Are you sure you want to deploy to ALL environments? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "Starting sequential deployment to all environments..."
echo ""

# Deploy to Development
echo "=========================================="
echo "🛠️  STEP 1/3: Deploying to Development"
echo "=========================================="
if ! "$SCRIPT_DIR/deploy-development.sh"; then
    echo "❌ Development deployment failed! Stopping here."
    exit 1
fi

echo ""
echo "✅ Development deployment completed"
echo ""
read -p "Continue to staging? (yes/no): " continue_staging
if [ "$continue_staging" != "yes" ]; then
    echo "❌ Deployment stopped after development"
    exit 0
fi

# Deploy to Staging
echo ""
echo "=========================================="
echo "🧪 STEP 2/3: Deploying to Staging"
echo "=========================================="
if ! "$SCRIPT_DIR/deploy-staging.sh"; then
    echo "❌ Staging deployment failed! Stopping here."
    exit 1
fi

echo ""
echo "✅ Staging deployment completed"
echo ""
read -p "Continue to production? (yes/no): " continue_production
if [ "$continue_production" != "yes" ]; then
    echo "❌ Deployment stopped after staging"
    exit 0
fi

# Deploy to Production
echo ""
echo "=========================================="
echo "🚀 STEP 3/3: Deploying to Production"
echo "=========================================="
if ! "$SCRIPT_DIR/deploy-production.sh"; then
    echo "❌ Production deployment failed!"
    exit 1
fi

echo ""
echo "🎉 ALL DEPLOYMENTS COMPLETED SUCCESSFULLY!"
echo "=========================================="
echo "✅ Development: Deployed"
echo "✅ Staging: Deployed"
echo "✅ Production: Deployed"
echo ""
echo "⏰ All deployments completed at: $(date)"
```

```bash:/workspace/scripts/make-executable.sh
#!/bin/bash

# Make all deployment scripts executable

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Making deployment scripts executable..."

chmod +x "$SCRIPT_DIR/deploy-production.sh"
chmod +x "$SCRIPT_DIR/deploy-staging.sh" 
chmod +x "$SCRIPT_DIR/deploy-development.sh"
chmod +x "$SCRIPT_DIR/deploy-all.sh"

echo "✅ All deployment scripts are now executable"
echo ""
echo "Available deployment scripts:"
echo "  📁 $SCRIPT_DIR/deploy-production.sh"
echo "  📁 $SCRIPT_DIR/deploy-staging.sh"
echo "  📁 $SCRIPT_DIR/deploy-development.sh"
echo "  📁 $SCRIPT_DIR/deploy-all.sh"
```

## 🚀 **Usage Instructions:**

### **Make Scripts Executable (Run Once):**
```bash
cd /workspace
chmod +x scripts/*.sh
```

### **Deploy to Specific Environments:**
```bash
# Deploy to production (with confirmation)
./scripts/deploy-production.sh

# Deploy to staging (with confirmation)
./scripts/deploy-staging.sh

# Deploy to development (no confirmation needed)
./scripts/deploy-development.sh

# Deploy to all environments sequentially (with confirmations)
./scripts/deploy-all.sh
```

## ✨ **Features of These Scripts:**

1. **🔍 Pre-flight Checks**: Verify files and configuration exist
2. **✅ Environment Validation**: Confirm target environment before deployment
3. **⚠️ Safety Confirmations**: Required for production and staging
4. **📊 Clear Output**: Shows progress and results
5. **🛡️ Error Handling**: Stops on errors and provides troubleshooting hints
6. **📍 Server Display**: Shows which server will be targeted
7. **⏰ Timestamps**: Track deployment timing
8. **🎯 Explicit Targeting**: Uses `--limit` to ensure correct environment

This gives you a clean, safe way to deploy to any environment with proper confirmations and error handling!
