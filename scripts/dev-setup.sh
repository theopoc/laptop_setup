#!/usr/bin/env bash
#
# Development Environment Setup Script
# This script automates the setup of your development environment for the Ansible playbook repository
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

log_success() {
    echo -e "${GREEN}✅ ${NC}$1"
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${NC}$1"
}

log_error() {
    echo -e "${RED}❌ ${NC}$1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "Detected macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        log_info "Detected Linux"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    local missing=()

    # Essential tools
    if ! command_exists git; then
        missing+=("git")
    fi

    if ! command_exists python3; then
        missing+=("python3")
    fi

    if ! command_exists pip3; then
        missing+=("pip3")
    fi

    # macOS specific
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            log_warning "Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi

    # Linux specific
    if [[ "$OS" == "linux" ]]; then
        if ! command_exists apt-get && ! command_exists dnf && ! command_exists yum; then
            log_error "No supported package manager found (apt-get, dnf, yum)"
            exit 1
        fi
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Please install them and run this script again"
        exit 1
    fi

    log_success "All prerequisites satisfied"
}

# Install Python dependencies
install_python_deps() {
    log_info "Installing Python dependencies..."

    # Upgrade pip
    python3 -m pip install --upgrade pip

    # Install Ansible and related tools
    pip3 install --user \
        ansible \
        ansible-lint \
        yamllint \
        molecule \
        molecule-plugins[podman] \
        jmespath \
        netaddr

    log_success "Python dependencies installed"
}

# Install pre-commit
setup_pre_commit() {
    log_info "Setting up pre-commit hooks..."

    if ! command_exists pre-commit; then
        pip3 install --user pre-commit
    fi

    # Install pre-commit hooks
    pre-commit install
    pre-commit install --hook-type commit-msg

    # Initialize secrets baseline
    if [ ! -f .secrets.baseline ]; then
        log_info "Creating secrets baseline..."
        pip3 install --user detect-secrets
        detect-secrets scan --baseline .secrets.baseline
    fi

    log_success "Pre-commit hooks configured"
}

# Install Podman (for Molecule testing)
install_podman() {
    log_info "Checking Podman installation..."

    if command_exists podman; then
        log_success "Podman already installed"
        return
    fi

    if [[ "$OS" == "macos" ]]; then
        log_info "Installing Podman via Homebrew..."
        brew install podman
        podman machine init
        podman machine start
    elif [[ "$OS" == "linux" ]]; then
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y podman
        elif command_exists dnf; then
            sudo dnf install -y podman
        else
            log_warning "Please install Podman manually"
            return
        fi
    fi

    log_success "Podman installed"
}

# Install Ansible Galaxy dependencies
install_galaxy_deps() {
    log_info "Installing Ansible Galaxy dependencies..."

    if [ -f requirements.yml ]; then
        ansible-galaxy install -r requirements.yml
        log_success "Galaxy dependencies installed"
    else
        log_warning "No requirements.yml found, skipping"
    fi
}

# Setup configuration files
setup_configs() {
    log_info "Setting up configuration files..."

    # Create hosts file if it doesn't exist
    if [ ! -f hosts ]; then
        cat > hosts << EOF
# Ansible Inventory File
# This playbook runs locally on your machine (connection: local)
# No need to specify ansible_user - it automatically uses your current user

[all]
127.0.0.1
EOF
        log_success "Created hosts file"
    fi

    # Create local ansible.cfg if it doesn't exist
    if [ ! -f ansible.cfg ]; then
        cat > ansible.cfg << 'EOF'
[defaults]
inventory = hosts
roles_path = ./roles
host_key_checking = False
retry_files_enabled = False
callbacks_enabled = profile_tasks, timer
stdout_callback = yaml

[privilege_escalation]
become = True
become_method = sudo
become_ask_pass = True
EOF
        log_success "Created ansible.cfg"
    fi

    # Create .secrets.baseline for detect-secrets
    if [ ! -f .secrets.baseline ]; then
        log_info "Initializing secrets detection baseline..."
        detect-secrets scan --baseline .secrets.baseline || true
    fi
}

# Install development tools
install_dev_tools() {
    log_info "Installing development tools..."

    if [[ "$OS" == "macos" ]]; then
        # macOS specific tools
        if ! command_exists shellcheck; then
            brew install shellcheck
        fi
        if ! command_exists markdownlint; then
            brew install markdownlint-cli
        fi
    else
        # Linux specific tools
        log_info "Installing shellcheck..."
        if command_exists apt-get; then
            sudo apt-get install -y shellcheck
        fi
    fi

    log_success "Development tools installed"
}

# Validate setup
validate_setup() {
    log_info "Validating setup..."

    local errors=0

    # Check Ansible
    if ! ansible --version >/dev/null 2>&1; then
        log_error "Ansible not working properly"
        ((errors++))
    fi

    # Check ansible-lint
    if ! ansible-lint --version >/dev/null 2>&1; then
        log_error "ansible-lint not working properly"
        ((errors++))
    fi

    # Check pre-commit
    if ! pre-commit --version >/dev/null 2>&1; then
        log_error "pre-commit not working properly"
        ((errors++))
    fi

    # Check syntax
    if ! ansible-playbook main.yml --syntax-check -i hosts >/dev/null 2>&1; then
        log_error "Playbook syntax check failed"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        log_success "All validation checks passed!"
        return 0
    else
        log_error "$errors validation check(s) failed"
        return 1
    fi
}

# Run initial tests
run_initial_tests() {
    log_info "Running initial tests..."

    # Run pre-commit on all files
    log_info "Running pre-commit hooks..."
    if pre-commit run --all-files; then
        log_success "Pre-commit checks passed"
    else
        log_warning "Some pre-commit checks failed (this is normal for initial setup)"
    fi

    # Test playbook syntax
    log_info "Testing playbook syntax..."
    if ansible-playbook main.yml --syntax-check -i hosts; then
        log_success "Playbook syntax valid"
    else
        log_error "Playbook syntax check failed"
    fi
}

# Print next steps
print_next_steps() {
    cat << EOF

${GREEN}========================================${NC}
${GREEN}🎉 Development Environment Setup Complete!${NC}
${GREEN}========================================${NC}

${BLUE}Next Steps:${NC}

1. ${YELLOW}Update Configuration${NC}
   - Edit ${BLUE}group_vars/all.yml${NC} with your settings
   - Update ${BLUE}hosts${NC} file with your inventory

2. ${YELLOW}Test Your Setup${NC}
   ${BLUE}# Run syntax check${NC}
   ansible-playbook main.yml --syntax-check -i hosts

   ${BLUE}# Run in check mode${NC}
   ansible-playbook main.yml -i hosts --check

   ${BLUE}# Test specific role with Molecule${NC}
   cd roles/base-tools && molecule test

3. ${YELLOW}Development Workflow${NC}
   ${BLUE}# Pre-commit will run automatically on git commit${NC}
   ${BLUE}# Or run manually:${NC}
   pre-commit run --all-files

   ${BLUE}# Run linting${NC}
   ansible-lint

4. ${YELLOW}Useful Commands${NC}
   ${BLUE}# Run specific role${NC}
   ansible-playbook main.yml -i hosts --tags <role_name>

   ${BLUE}# Run with verbose output${NC}
   ansible-playbook main.yml -i hosts -vvv

   ${BLUE}# Test role with Molecule${NC}
   cd roles/<role_name> && molecule converge

${GREEN}Happy automating! 🚀${NC}

EOF
}

# Main execution
main() {
    cat << EOF
${BLUE}╔════════════════════════════════════════╗${NC}
${BLUE}║  Ansible Playbook Dev Setup            ║${NC}
${BLUE}║  Setting up your development environment ║${NC}
${BLUE}╚════════════════════════════════════════╝${NC}

EOF

    detect_os
    check_prerequisites
    install_python_deps
    install_galaxy_deps
    setup_pre_commit
    install_podman
    setup_configs
    install_dev_tools
    validate_setup
    run_initial_tests
    print_next_steps
}

# Run main function
main "$@"
