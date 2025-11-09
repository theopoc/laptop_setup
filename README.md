# Ansible Playbook for macOS and Ubuntu

[![CI/CD Pipeline](https://github.com/TheoPoc/laptop_setup/actions/workflows/ci.yml/badge.svg)](https://github.com/TheoPoc/laptop_setup/actions/workflows/ci.yml)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Ansible Lint](https://img.shields.io/badge/ansible--lint-passing-success)](https://github.com/ansible/ansible-lint)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovatebot&logoColor=white)](https://renovatebot.com/)

This repository contains an Ansible playbook for automating workstation setup on both macOS and Ubuntu. It installs essential development tools, configures your development environment, and manages applications.

**NEW:** Comprehensive workflow automation with CI/CD, pre-commit hooks, and automated testing! See [AUTOMATION.md](AUTOMATION.md) for details.

## Supported Operating Systems

- **macOS** (Intel and Apple Silicon)
- **Ubuntu** 20.04 LTS and later

## Installation

### Prerequisites

#### macOS

1. Install Command Line Tools:

   ```bash
   xcode-select --install
   ```

2. Ensure you're logged in to your Apple ID (for App Store installations)

**Note:** The setup script will automatically check for Terminal Full Disk Access and guide you through granting it if needed.

#### Ubuntu

1. Update your system:

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Install required packages:

   ```bash
   sudo apt install -y git python3 python3-pip
   ```

### Common Setup Steps

1. Clone the repository and run the setup script:

   ```bash
   git clone https://github.com/TheoPoc/laptop_setup.git
   cd laptop_setup
   ./setup.sh
   ```

2. **IMPORTANT: Configure your personal settings**

   Edit [group_vars/all.yml](group_vars/all.yml) and update the following:

   **Git Configuration (Required):**

   ```yaml
   git_username: "Your Name"  # Replace with your full name
   git_email: "your.email@example.com"  # Replace with your actual email address
   ```

   > **Note:** These values will be used to configure your global Git identity. Make sure to use your real name and email address.
   > If you don't want to configure Git, set `git_enabled: false`

   **Optional Customizations:**
   - Customize packages, tools, and applications in the same file
   - Review and modify the list of Homebrew packages (macOS) or APT packages (Ubuntu)
   - Adjust IDE extensions, terminal workflows, and other preferences

## Execution

### Run the full playbook

**macOS:**

```bash
ansible-playbook main.yml -i hosts --ask-become-pass
```

**Ubuntu:**

```bash
ansible-playbook main.yml -i hosts --ask-become-pass
```

### Run specific roles with tags

Install only base tools (Homebrew/APT packages):

```bash
ansible-playbook main.yml -i hosts --tags base-tools --ask-become-pass
```

Install only Cursor IDE:

```bash
ansible-playbook main.yml -i hosts --tags cursor --ask-become-pass
```

Configure only Git:

```bash
ansible-playbook main.yml -i hosts --tags git --ask-become-pass
```

Available tags: `base-tools`, `cursor`, `mise`, `zsh`, `git`, `warp`, `vim`, `gpg`, `rancher-desktop`, `appstore` (macOS only), `macos_settings` (macOS only)

## Quick Reference

### Using Makefile (Recommended)

The repository includes a Makefile for convenient command shortcuts:

```bash
# Setup and installation
make setup              # One-command development environment setup
make install            # Install Ansible and dependencies

# Testing
make test               # Run all tests (linting + Molecule)
make test-role ROLE=cursor  # Test specific role
make check              # Run playbook in check mode

# Linting
make lint               # Run all linters
make validate           # Run all validations

# Running playbook
make run                # Run full playbook
make run-tag TAG=mise   # Run specific role

# Development
make pre-commit         # Run pre-commit hooks manually
make list-roles         # List all available roles
make list-tags          # List all available tags

# For more commands
make help
```

See [AUTOMATION.md](AUTOMATION.md) for comprehensive automation documentation.

## What Gets Installed

### Common to Both macOS and Ubuntu

- **Base development tools**: git, python, curl, wget, jq, ripgrep, htop, etc.
- **DevOps tools** (via mise): terraform, kubectl, helm, k9s, awscli, packer, vault, etc.
- **IDEs and terminals**: Cursor, Warp
- **Shell**: zsh with Oh My Zsh and Powerlevel10k
- **Container runtime**: Rancher Desktop
- **Version managers**: mise (replacement for rtx)
- **Git configuration** with OS-specific credential helpers

### macOS-Specific

- **Package manager**: Homebrew
- **App Store apps**: Magnet, Bitwarden, Amphetamine, etc.
- **Terminal**: iTerm2 (optional)
- **System settings**: Dock, Finder, Safari configurations
- **Rosetta 2**: For Apple Silicon Macs

### Ubuntu-Specific

- **Package manager**: APT + Snap
- **Applications**: Installed via snap or direct downloads
- **Git credential helper**: libsecret

## Architecture

The playbook is organized into modular roles:

- **base-tools**: OS-agnostic package installation (Homebrew for macOS, APT for Ubuntu)
- **cursor**: Cross-platform IDE with OS-specific configurations
- **zsh**: Shell configuration with framework
- **mise**: Development tools version manager
- **git**: Git configuration with OS-specific credential helpers
- **warp**: Modern terminal (supports both macOS and Ubuntu)
- **rancher-desktop**: Container runtime
- **vim**, **gpg**, **gita**, **copier**, **uv**: Cross-platform tools

### macOS-only roles

- **appstore**: Mac App Store applications
- **rosetta**: ARM64 emulation for Intel apps
- **iterm2**: macOS terminal
- **macos_settings**: System preferences

## Customization

Edit the unified configuration file [group_vars/all.yml](group_vars/all.yml) to customize:

- **Homebrew packages** (macOS): taps, formulae, and casks
- **Cursor IDE**: Extensions, settings, keybindings, MCP configuration
- **Mise tools**: Version manager tools (terraform, kubectl, helm, etc.)
- **Git configuration**: Username, email, and credential helper
- **Warp workflows**: Custom terminal workflows
- **App Store apps** (macOS): Applications to install
- **Dock applications** (macOS): Apps to display in the Dock
- And much more!

**Note**: The configuration automatically adapts to your OS (macOS or Ubuntu) using OS-specific detection in the roles.

## macOS: Create a Rosetta iTerm2

For Apple Silicon Macs running x86_64 applications:

- Open Finder and navigate to Applications menu
- Copy `iTerm2.app` to `Rosetta iTerm2.app`
- Right-click `Rosetta iTerm2.app`, select "Get Info"
- Enable "Open using Rosetta"
