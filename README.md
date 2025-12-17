# Ansible Playbook for macOS, Ubuntu, and Debian

[![CI/CD Pipeline](https://github.com/TheoPoc/laptop_setup/actions/workflows/ci.yml/badge.svg)](https://github.com/TheoPoc/laptop_setup/actions/workflows/ci.yml)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Ansible Lint](https://img.shields.io/badge/ansible--lint-passing-success)](https://github.com/ansible/ansible-lint)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/TheoPoc/laptop_setup)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovatebot&logoColor=white)](https://renovatebot.com/)

This repository contains an Ansible playbook for automating workstation setup on macOS, Ubuntu, and Debian. It installs essential development tools, configures your development environment, and manages applications.

## Supported Operating Systems

- **macOS** (Intel and Apple Silicon)
- **Ubuntu** 24.04 LTS and later
- **Debian** 12 (Bookworm) and later

## Installation

### Prerequisites

**macOS:**
- Install Command Line Tools: `xcode-select --install`
- Log in to your Apple ID (for App Store installations)

**Ubuntu/Debian:**
```
sudo apt update && sudo apt upgrade -y && sudo apt install -y git curl
```
### Setup

1. Clone and run the setup script:

   ```bash
   git clone --branch feat/implement-taskfile-mise https://github.com/TheoPoc/laptop_setup.git
   curl https://mise.run | sh
   cd laptop_setup
   mise trust -qa && mise install -yq && eval "$(mise activate bash)"
   ```
> Make sure you have mise installed
2. **Configure your settings** in [group_vars/all.yml](group_vars/all.yml):

   ```yaml
   git_username: "Your Name"
   git_email: "your.email@example.com"
   ```

   Customize packages, tools, IDE extensions, and other preferences in the same file

## Usage

Initialize the stack (install tools and dependencies):

```bash
task init
```

Run the full playbook:

```bash
task run
```

Run specific roles with tags:

```bash
task run cursor              # Install Cursor IDE
task run git                 # Configure Git
task run base-tools          # Install base packages
```

Run playbook in check mode (dry-run):

```bash
task check
```

**Available tags:** `base-tools`, `claude-code`, `cursor`, `mise`, `zsh`, `git`, `warp`, `vim`, `gpg`, `rancher-desktop`, `appstore`, `macos_settings`, `uv`, and more

## Quick Reference

Common task commands:

```bash
task init                # Initialize stack (install tools, dependencies, and Ansible roles)
task run                 # Run full playbook
task run <tag>           # Run playbook by tag (e.g., task run cursor)
task check               # Run playbook in check mode (dry-run)
task lint                # Run all linters (ansible-lint, yamllint, syntax-check)
task pre-commit          # Run pre-commit hooks on all files
task test <role>         # Run Molecule tests for a specific role
task full-test           # Run Molecule tests for all roles
task list-tags           # List all available tags
task update-galaxy       # Update Ansible Galaxy roles
task version             # Show versions of installed tools
task --list-all          # Show all available tasks with descriptions
```

## What Gets Installed

**Cross-platform:**
- Base tools (git, python, curl, jq, ripgrep, htop), DevOps tools (terraform, kubectl, helm, k9s, awscli), Claude Code CLI, Cursor IDE, Warp terminal, zsh + Oh My Zsh, Rancher Desktop, mise, vim, gpg

**macOS:**
- Homebrew, App Store apps (Magnet, Bitwarden), iTerm2, system settings, Rosetta 2 (Apple Silicon)

**Ubuntu/Debian:**
- APT + Snap packages, libsecret credential helper

## Architecture

The playbook is organized into modular roles:

- **base-tools**: OS-agnostic package installation (Homebrew for macOS, APT for Ubuntu)
- **claude-code**: Claude Code CLI tool (Homebrew for macOS, curl install for Ubuntu/Debian)
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

All settings are in [group_vars/all.yml](group_vars/all.yml):
- Packages (Homebrew/APT), Cursor IDE (extensions, settings, MCP), DevOps tools (mise), Git config, Warp workflows, App Store apps, Dock apps

Configuration automatically adapts to your OS.
