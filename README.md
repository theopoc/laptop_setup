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
sudo apt update && \
sudo apt upgrade -y && \
sudo apt install -y git curl
```
### Setup

1. Clone and run the setup script:

   ```bash
   git clone https://github.com/TheoPoc/laptop_setup.git
   curl https://mise.run | sh
   eval "$($HOME/.local/bin/mise activate bash)"
   cd laptop_setup
   mise trust -qa && mise install -yq && eval "$($HOME/.local/bin/mise activate bash)"
   ```
2. **Configure your settings** in [group_vars/all.yml](group_vars/all.yml):

   ```yaml
   git_username: "Your Name"
   git_email: "your.email@example.com"
   ```

   Customize packages, tools, IDE extensions, and other preferences in the same file

3. Initialize the stack (install tools and dependencies):

   ```bash
   task init
   ```

4. Run the playbook:

   ```bash
   task run
   ```

## Usage

You can see all availables commands with
   ```bash
   task
   ```

Common task commands:

```bash
task ansiblelint:               Launch ansible lint              (aliases: alint)
task ansiblesyntaxecheck:       Launch ansible syntax check      (aliases: ascheck)
task check:                     Run playbook in check mode
task default:                   Display helper
task full-test:                 Run Molecule test on all roles
task init:                      Init stack
task lint:                      Run all linters
task list-tags:                 List all available tags
task pre-commit:                Run pre-commit on all files
task run:                       Run full playbook
task update-galaxy:             Update Ansible Galaxy roles
task version:                   Show versions of installed tools
task yamllint:                  Run yamllint      (aliases: ylint)
task converge:*:                Run Molecule converge for specific role
task destroy:*:                 Destroy Molecule instances for specific role
task login:*:*:                 Login to Molecule test container
task run:*:                     Run playbook by tag
task test:*:                    Run Molecule tests for specific role
task verify:*:                  Run Molecule verify for specific role
```

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

## What Gets Installed

**Cross-platform:**
- Base tools (git, python, curl, jq, ripgrep, htop), DevOps tools (terraform, kubectl, helm, k9s, awscli), Claude Code CLI, Cursor IDE, Warp terminal, zsh + Oh My Zsh, Rancher Desktop, mise, vim, gpg

**macOS:**
- Homebrew, App Store apps (Magnet, Bitwarden), iTerm2, system settings, Rosetta 2 (Apple Silicon)

**Ubuntu/Debian:**
- APT + Snap packages

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

## Troubleshooting

### Molecule tests fail with "Failed to create temporary directory" (Docker rootless)

If Molecule containers are created successfully but Ansible fails to connect with:

```
fatal: [ubuntu-24-04]: UNREACHABLE! => {"msg": "Failed to create temporary directory..."}
```

This is caused by a mismatch between the Docker CLI and the Python Docker SDK when using **Docker rootless mode**. The Docker CLI respects the active Docker context (e.g. `rootless` using `unix:///run/user/<uid>/docker.sock`), but the Python Docker SDK defaults to `unix:///var/run/docker.sock` (root daemon). Molecule creates containers on the root daemon while Ansible tries to reach them on the rootless daemon.

**Diagnosis:**

```bash
docker context ls  # Look for "rootless *" as active context
```

**Solution:**

The `Taskfile.yml` auto-detects the rootless Docker socket and sets `DOCKER_HOST` accordingly. If you run Molecule outside of Task, export the variable manually:

```bash
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
```

Or switch Docker back to the default (root) context:

```bash
docker context use default
```
