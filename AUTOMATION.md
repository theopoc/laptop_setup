# Workflow Automation Guide

This document describes the comprehensive workflow automation implemented for this Ansible playbook repository.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Pre-commit Hooks](#pre-commit-hooks)
- [Development Tools](#development-tools)
- [Release Management](#release-management)
- [Best Practices](#best-practices)

## Overview

The automation stack includes:

- **CI/CD Pipeline**: Automated testing and validation on every push/PR
- **Pre-commit Hooks**: Local validation before commits
- **PR Automation**: Auto-labeling, checks, and review requests
- **Release Automation**: Semantic versioning and changelog generation
- **Development Setup**: One-command environment setup
- **Testing**: Molecule tests for all roles

## Quick Start

### Initial Setup

```bash
# One-command setup (recommended)
make setup

# Or manual setup
./scripts/dev-setup.sh

# Or step-by-step
make install
make galaxy-install
make pre-commit-install
```

### Daily Workflow

```bash
# Run all checks before committing
make validate

# Test specific role
make test-role ROLE=cursor

# Run playbook in check mode
make check

# Run specific role
make run-tag TAG=mise
```

## GitHub Actions Workflows

### 1. CI/CD Pipeline (`.github/workflows/ci.yml`)

**Triggers:**

- Push to `main`, `develop`, or `feat/**` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Jobs:**

#### Lint and Validate

- Runs `ansible-lint` on all playbooks and roles
- Runs `yamllint` on all YAML files
- Validates Ansible syntax
- Scans for secrets with Gitleaks

#### Test Roles

- Matrix testing for all roles with Molecule
- Tests run in Ubuntu 24.04 containers with Podman
- Parallel execution for faster feedback
- Uploads test results as artifacts

**Tested roles:**

- base-tools
- cursor
- git
- mise
- rancher-desktop
- uv
- zsh

#### Integration Test

- Runs full playbook in check mode
- Validates cross-role dependencies
- Ensures playbook syntax is valid

#### Security Scan

- Trivy vulnerability scanner
- Hardcoded credential detection
- Security results uploaded to GitHub Security tab

#### Documentation

- Auto-generates role documentation
- Validates documentation is up-to-date
- Runs on main branch only

### 2. PR Automation (`.github/workflows/pr-automation.yml`)

**Features:**

#### Auto-Labeling

- Labels PRs based on changed files
- Size labels (xs/s/m/l/xl)
- Role-specific labels
- Platform labels (macOS/Ubuntu)
- Area labels (ci/cd, testing, security)

#### PR Checks

- Validates PR title follows conventional commits
- Analyzes changed roles
- Checks for Molecule tests
- Posts automated checklist comment
- Warns about missing tests

#### Auto-Approve Dependabot

- Automatically approves Dependabot PRs
- Speeds up dependency updates

#### Review Requests

- Auto-assigns reviewers based on CODEOWNERS
- Configurable per file pattern

### 3. Release Workflow (`.github/workflows/release.yml`)

**Triggers:**

- Push to `main` branch
- Tags starting with `v*`
- Manual dispatch with version bump type

**Features:**

#### Automated Releases

- Generates changelog from commits
- Categorizes changes (features, fixes, docs, chores)
- Creates GitHub release with notes
- Includes relevant files

#### Version Bumping

```bash
# Trigger manual release
# Go to Actions → Release → Run workflow
# Select: patch, minor, or major
```

#### Changelog Maintenance

- Auto-updates CHANGELOG.md
- Follows Keep a Changelog format
- Groups by semantic version

## Pre-commit Hooks

Configuration file: `.pre-commit-config.yaml`

### Enabled Hooks

#### General File Checks

- Trailing whitespace removal
- End of file fixer
- YAML validation
- Large file detection
- Merge conflict detection
- Private key detection
- Line ending normalization
- Shebang validation

#### Ansible-Specific

- `ansible-lint`: Comprehensive Ansible linting
- `yamllint`: YAML formatting and style
- Ansible syntax check
- Role dependency validation
- Molecule test verification

#### Shell Scripts

- ShellCheck for bash scripts
- Shebang verification

#### Markdown

- Markdownlint for documentation

#### Security

- `detect-secrets`: Prevents committing secrets
- Uses baseline file for known false positives

#### Custom Hooks

- **TODO/FIXME checker**: Lists TODO comments
- **group_vars validator**: Validates configuration structure
- **Role dependency checker**: Ensures proper meta/main.yml
- **Molecule test checker**: Warns if tests missing

### Installation

```bash
# Install pre-commit
pip3 install --user pre-commit

# Install hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Run manually
pre-commit run --all-files

# Update hooks
pre-commit autoupdate
```

## Development Tools

### Makefile Commands

The `Makefile` provides convenient shortcuts:

#### Setup Commands

```bash
make setup              # Initial environment setup
make install            # Install Ansible and dependencies
make galaxy-install     # Install Galaxy roles
make pre-commit-install # Setup pre-commit hooks
```

#### Testing Commands

```bash
make test                      # Run all tests
make test-role ROLE=cursor     # Test specific role
make molecule-test             # Run Molecule for all roles
make molecule-converge ROLE=x  # Run converge only
make molecule-verify ROLE=x    # Run verify only
make molecule-login ROLE=x     # SSH into test container
make molecule-destroy ROLE=x   # Destroy test container
```

#### Linting Commands

```bash
make lint           # Run all linters
make ansible-lint   # Run ansible-lint only
make yamllint       # Run yamllint only
```

#### Playbook Commands

```bash
make check              # Run playbook in check mode
make syntax-check       # Check syntax only
make run                # Run full playbook
make run-tag TAG=mise   # Run specific role
```

#### Utility Commands

```bash
make clean          # Clean temporary files
make docs           # Generate documentation
make list-roles     # List all roles
make list-tags      # List all tags
make version        # Show tool versions
make validate       # Run all validations
```

### Development Setup Script

Location: `scripts/dev-setup.sh`

**What it does:**

- Detects OS (macOS/Linux)
- Checks prerequisites
- Installs Python dependencies
- Sets up Ansible and tools
- Configures pre-commit hooks
- Installs Podman for testing
- Creates default configs
- Validates installation
- Runs initial tests

**Usage:**

```bash
# Make executable (already done)
chmod +x scripts/dev-setup.sh

# Run setup
./scripts/dev-setup.sh

# Or via Makefile
make setup
```

## Release Management

### Semantic Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes
- **MINOR** (v1.0.0 → v1.1.0): New features, backwards compatible
- **PATCH** (v1.0.0 → v1.0.1): Bug fixes

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples:**

```bash
git commit -m "feat(cursor): add MCP server configuration"
git commit -m "fix(zsh): resolve plugin loading issue on macOS"
git commit -m "docs: update installation instructions"
git commit -m "ci: add Molecule testing workflow"
```

### Creating a Release

#### Automatic (Recommended)

1. Merge PR to `main` branch
2. Go to Actions → Release → Run workflow
3. Select version bump type (patch/minor/major)
4. Workflow creates tag and release automatically

#### Manual

```bash
# Create and push tag
git tag -a v1.2.3 -m "Release v1.2.3"
git push origin v1.2.3

# Release workflow triggers automatically
```

### Changelog

The `CHANGELOG.md` is automatically maintained:

- Updated on every push to `main`
- Generated from commit messages
- Grouped by version and type
- Follows Keep a Changelog format

## Best Practices

### Before Committing

1. **Run pre-commit hooks**

   ```bash
   pre-commit run --all-files
   ```

2. **Validate changes**

   ```bash
   make validate
   ```

3. **Test affected roles**

   ```bash
   make test-role ROLE=<changed_role>
   ```

### Before Creating PR

1. **Ensure tests pass locally**

   ```bash
   make test
   ```

2. **Check playbook syntax**

   ```bash
   make check
   ```

3. **Update documentation** if needed

4. **Follow commit message format**

### When Reviewing PRs

1. Check automated PR comment for:
   - Changed roles
   - Missing Molecule tests
   - Testing checklist

2. Verify CI checks pass:
   - Linting
   - Role tests
   - Integration tests
   - Security scans

3. Ensure documentation is updated

4. Verify idempotency (changes run twice = no changes)

### Molecule Testing

#### Running Tests

```bash
# Full test cycle (create, converge, verify, destroy)
cd roles/cursor
molecule test

# Quick iteration
molecule converge  # Run playbook
molecule verify    # Run tests
molecule login     # Debug in container
molecule destroy   # Clean up
```

#### Writing Tests

1. **converge.yml**: Playbook to test

   ```yaml
   - name: Converge
     hosts: all
     roles:
       - role: cursor
   ```

2. **verify.yml**: Validation tests

   ```yaml
   - name: Verify
     hosts: all
     tasks:
       - name: Check Cursor is installed
         command: which cursor
         register: cursor_check
         failed_when: cursor_check.rc != 0
   ```

3. **molecule.yml**: Configuration

   ```yaml
   platforms:
     - name: ubuntu-cursor
       image: geerlingguy/docker-ubuntu2404-ansible:latest
   ```

### CI/CD Best Practices

1. **All roles should have Molecule tests**
   - Ensures quality
   - Catches regressions
   - Documents expected behavior

2. **Keep workflows fast**
   - Use matrix for parallel testing
   - Cache dependencies
   - Fail fast where appropriate

3. **Security scanning**
   - Review security scan results
   - Update vulnerable dependencies
   - Don't commit secrets

4. **Documentation**
   - Keep CLAUDE.md updated
   - Update role README files
   - Document breaking changes

## Troubleshooting

### Pre-commit Issues

```bash
# Update hooks
pre-commit autoupdate

# Clear cache
pre-commit clean

# Reinstall
pre-commit uninstall
pre-commit install
```

### Molecule Issues

```bash
# Reset Podman
podman system reset

# Rebuild containers
molecule destroy
molecule test

# Check Podman status
podman info
```

### CI Failures

1. Check workflow logs in GitHub Actions
2. Reproduce locally:

   ```bash
   make lint
   make test
   ```

3. Fix issues and push again

### Linting Errors

```bash
# Show detailed errors
ansible-lint -v

# Auto-fix some issues
yamllint --fix .

# Check specific file
ansible-lint roles/cursor/tasks/main.yml
```

## Additional Resources

- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)

## Support

For issues or questions:

1. Check this documentation
2. Review workflow logs
3. Check role-specific README files
4. Review CLAUDE.md for architecture details
5. Open an issue on GitHub

---

**Last Updated:** 2025-10-16
