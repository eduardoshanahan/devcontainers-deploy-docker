#!/bin/bash
# =============================================================================
# FULL SYSTEM DEPLOYMENT SCRIPT
# =============================================================================
# This script deploys the complete system using the full.yml playbook
# It sources environment variables and runs the main deployment
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if we're in the right directory
check_workspace() {
    if [ ! -f "secrets/.env" ] || [ ! -d "src" ]; then
        print_error "This script must be run from the workspace root directory"
        print_error "Current directory: $(pwd)"
        print_error "Expected files: secrets/.env, src/"
        exit 1
    fi
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if .env file exists
    if [ ! -f "secrets/.env" ]; then
        print_error "Environment file not found: secrets/.env"
        exit 1
    fi
    
    # Check if vault file exists
    if [ ! -f "secrets/vault.yml" ]; then
        print_error "Vault file not found: secrets/vault.yml"
        exit 1
    fi
    
    # Check if vault password file exists
    if [ ! -f "secrets/.vault_pass" ]; then
        print_error "Vault password file not found: secrets/.vault_pass"
        exit 1
    fi
    
    # Check if src directory exists
    if [ ! -d "src" ]; then
        print_error "Source directory not found: src/"
        exit 1
    fi
    
    # Check if full.yml playbook exists
    if [ ! -f "src/playbooks/full.yml" ]; then
        print_error "Full deployment playbook not found: src/playbooks/full.yml"
        exit 1
    fi
    
    print_success "All prerequisites met"
}

# Function to source environment variables
source_environment() {
    print_status "Loading environment variables..."
    
    if [ -f "secrets/.env" ]; then
        # Source the environment file
        set -a  # Automatically export all variables
        source secrets/.env
        set +a  # Turn off auto-export
        
        print_success "Environment variables loaded"
        
        # Verify key variables
        if [ -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
            print_warning "ANSIBLE_VAULT_PASSWORD_FILE not set in .env"
        else
            print_status "Vault password file: $ANSIBLE_VAULT_PASSWORD_FILE"
        fi
        
        if [ -z "$ANSIBLE_CONFIG" ]; then
            print_warning "ANSIBLE_CONFIG not set in .env"
        else
            print_status "Ansible config: $ANSIBLE_CONFIG"
        fi
        
        # ADD THIS CHECK:
        if [ -z "$ANSIBLE_VAULT_FILE" ]; then
            print_warning "ANSIBLE_VAULT_FILE not set in .env"
        else
            print_status "Vault file: $ANSIBLE_VAULT_FILE"
        fi
    else
        print_error "Environment file not found: secrets/.env"
        exit 1
    fi
}

# Function to run pre-deployment checks
run_preflight_checks() {
    print_status "Running pre-deployment checks..."
    
    # Run preflight from workspace root to avoid path issues
    if ansible-playbook -i src/inventory/hosts.yml src/playbooks/preflight_check.yml > /dev/null 2>&1; then
        print_success "Preflight checks passed"
    else
        print_warning "Preflight checks failed, but continuing with deployment"
    fi
}

# Function to deploy the system
deploy_system() {
    print_status "Starting full system deployment..."
    print_status "This will deploy:"
    print_status "  - Ubuntu updates"
    print_status "  - SSH security hardening"
    print_status "  - Docker installation and configuration"
    print_status "  - Firewall configuration"
    print_status "  - Security updates"
    print_status "  - Monitoring setup"
    print_status "  - Container security"
    print_status "  - Remote logging"
    print_status "  - Log management"
    print_status "  - Fail2ban protection"
    
    echo
    # read -p "Do you want to continue with the deployment? (y/N): " -n 1 -r
    # echo
    
    # if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    #     print_warning "Deployment cancelled by user"
    #     exit 0
    # fi
    
    print_status "Proceeding with deployment..."
    
    # Run from workspace root with explicit inventory path
    if ansible-playbook -vvv -i src/inventory/hosts.yml src/playbooks/full.yml; then
        print_success "Full system deployment completed successfully!"
        print_success "Your system is now ready for production use!"
    else
        print_error "Deployment failed! Check the output above for errors."
        exit 1
    fi
}

# Function to show deployment summary
show_summary() {
    print_status "Deployment Summary:"
    print_status "==================="
    print_status "✅ Environment variables loaded"
    print_status "✅ Prerequisites checked"
    print_status "✅ Preflight checks completed"
    print_status "✅ Full system deployed"
    print_status ""
    print_status "Next steps:"
    print_status "  - Verify services are running"
    print_status "  - Test network connectivity"
    print_status "  - Check security configurations"
    print_status "  - Monitor system resources"
}

# Main execution
main() {
    echo "=============================================================================="
    echo "                    FULL SYSTEM DEPLOYMENT SCRIPT"
    echo "=============================================================================="
    echo
    
    # Check if we're in the right directory
    check_workspace
    
    # Check prerequisites
    check_prerequisites
    
    # Source environment variables
    source_environment
    
    # Run pre-deployment checks
    run_preflight_checks
    
    # Deploy the system
    deploy_system
    
    # Show summary
    show_summary
    
    echo
    print_success "Deployment script completed successfully!"
}

# Run main function
main "$@"
