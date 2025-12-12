#!/usr/bin/env bash

set -e
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "Detected macOS"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu)
                OS="ubuntu"
                log_info "Detected Ubuntu $VERSION_ID"
                ;;
            debian)
                OS="debian"
                log_info "Detected Debian $VERSION_ID"
                ;;
            *)
                log_error "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        log_error "Unsupported operating system"
        exit 1
    fi
}

# Install Homebrew (macOS only)
install_homebrew() {
    if command_exists brew; then
        log_success "Homebrew already installed"
        return
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Setup Homebrew environment
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    log_success "Homebrew installed"
}

# Install system dependencies for Debian/Ubuntu
install_debian_dependencies() {
    log_info "Updating package lists..."
    sudo apt-get update

    log_info "Installing system dependencies..."
    sudo apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        git \
        curl \
        software-properties-common

    log_success "System dependencies installed"
}

# Install Ansible
install_ansible() {
    if command_exists ansible; then
        log_success "Ansible already installed ($(ansible --version | head -n1))"
        return
    fi

    case "$OS" in
        macos)
            log_info "Installing Ansible via Homebrew..."
            brew install ansible
            ;;
        ubuntu|debian)
            log_info "Installing Ansible via pip3..."
            # Use --user flag to install in user's home directory
            python3 -m pip install --user ansible

            # Add user bin to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                export PATH="$HOME/.local/bin:$PATH"
                log_info "Added $HOME/.local/bin to PATH for this session"
                echo ""
                log_info "To make this permanent, add the following to your ~/.bashrc or ~/.zshrc:"
                echo -e "${YELLOW}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
                echo ""
            fi
            ;;
    esac

    log_success "Ansible installed"
}

# Install Ansible Galaxy collections
install_galaxy_collections() {
    if [[ ! -f requirements.yml ]]; then
        log_error "requirements.yml not found in current directory"
        exit 1
    fi

    if ! command_exists ansible-galaxy; then
        log_error "ansible-galaxy command not found. Ansible installation may have failed."
        exit 1
    fi

    log_info "Installing Ansible Galaxy collections..."
    ansible-galaxy install -r requirements.yml

    log_success "Ansible Galaxy collections installed"
}

# Print next steps
print_next_steps() {
    cat << EOF

${GREEN}========================================${NC}
${GREEN}Setup Complete!${NC}
${GREEN}========================================${NC}

${BLUE}Next Steps:${NC}

1. ${YELLOW}Configure your settings${NC}
   - Edit ${BLUE}group_vars/all.yml${NC} with your personal settings
   - Update ${BLUE}hosts${NC} file if needed

2. ${YELLOW}Run the playbook${NC}
   ${BLUE}ansible-playbook main.yml${NC}

3. ${YELLOW}Run specific roles using tags${NC}
   ${BLUE}ansible-playbook main.yml --tags <tag_name>${NC}

${GREEN}Available tags:${NC} base-tools, cursor, mise, zsh, git, warp, vim, gpg, rancher-desktop, appstore, macos_settings, uv

${GREEN}Happy automating! 🚀${NC}

EOF
}

# Main execution
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Ansible Playbook Setup${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    detect_os

    case "$OS" in
        macos)
            install_homebrew
            install_ansible
            ;;
        ubuntu|debian)
            install_debian_dependencies
            install_ansible
            ;;
    esac

    install_galaxy_collections
    print_next_steps
}

# Run main function
main "$@"
