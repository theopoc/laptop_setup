# Phase 1: Role Inventory - Debian Compatibility Audit

**Date**: 2025-12-09
**Branch**: `feat/debian-compatibility`
**Research**: [research.md](./research.md) | **Plan**: [plan.md](./plan.md)

## Summary

This document provides a comprehensive audit of all 16 Ansible roles in the repository, categorizing them by Debian compatibility status and defining implementation requirements for the 10 roles that need Debian support.

### Role Categories

| Category | Count | Roles |
|----------|-------|-------|
| ✅ **Debian-Compatible** | 6 | base-tools, cursor, mise, rancher-desktop, warp, zsh |
| 🔧 **Needs Debian Support** | 6 | copier, git, gita, gpg, uv, vim |
| 🍎 **macOS-Only** | 4 | appstore, iterm2, macos_settings, rosetta |
| **TOTAL** | **16** | |

## Debian-Compatible Roles (No Changes Required)

These roles already have `install-Debian.yml` files and should work on Debian 12 without modification. Testing will verify compatibility.

### 1. base-tools ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- APT package installation for core utilities
- Third-party repository setup with signed GPG keys
- Direct .deb downloads (Slack)
- Binary installations from GitHub releases (yq, lsd, dive, gopass, s5cmd, vsh, vkv, safe, pug, tfautomv, tfmv, hcledit)
- Postman tarball installation

**Action Required**: Verify Molecule tests pass on Debian 12 containers

---

### 2. cursor ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- Downloads Cursor .deb package from official URL
- Installs via dpkg with dependency fixing
- Idempotency via file existence checks

**Action Required**: Verify Molecule tests pass on Debian 12 containers

---

### 3. mise ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml` AND `tasks/install-Ubuntu.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- Adds mise official APT repository with GPG key
- Installs mise via apt package manager
- **Note**: Has BOTH `install-Debian.yml` and `install-Ubuntu.yml` files (investigate if needed)

**Action Required**:
1. Verify Molecule tests pass on Debian 12 containers
2. Investigate if `install-Ubuntu.yml` can be removed in favor of shared `install-Debian.yml`

---

### 4. rancher-desktop ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- Installs Rancher Desktop for container management

**Action Required**: Verify Molecule tests pass on Debian 12 containers

---

### 5. warp ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- Installs Warp terminal emulator

**Action Required**: Verify Molecule tests pass on Debian 12 containers

---

### 6. zsh ✅

**Current Status**: Full Debian support implemented
**Files**: `tasks/install-Debian.yml`, `vars/Debian.yml`
**Molecule Tests**: Yes (`molecule/default/`)

**Implementation Details**:
- Installs zsh shell via APT
- Configures zsh as default shell
- Sets up oh-my-zsh and plugins

**Action Required**: Verify Molecule tests pass on Debian 12 containers

---

## Roles Requiring Debian Support

These 6 roles need new `install-Debian.yml` task files and Molecule test updates to support Debian.

### 7. copier 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Installs `copier` (template generator) using `uv tool install copier`
- No OS-specific installation tasks - relies on mise + uv being installed

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   - Install copier dependencies: `python3-pip`, `python3-venv`
   - Verify uv is available via mise
   - Install copier using `uv tool install copier`

2. **Create `vars/Debian.yml`**:
   ```yaml
   copier_dependencies:
     - python3-pip
     - python3-venv
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - Ensure mise and uv roles run before copier

5. **Update `molecule/default/verify.yml`**:
   - Verify copier is in uv tool list
   - Test `copier --version` command

**Dependencies**: mise, uv
**Installation Method**: uv tool install (Python package)

---

### 8. git 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Pure configuration role (no installation tasks)
- Uses `community.general.git_config` module to set:
  - `user.name`
  - `user.email`
  - `credential.helper`

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   ```yaml
   - name: Install git via apt
     ansible.builtin.apt:
       name: git
       state: present
       update_cache: true
     become: true
   ```

2. **Create `vars/Debian.yml`**:
   ```yaml
   git_package: git
   git_credential_helper_default: "cache --timeout=3600"
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - Set test git configuration values in host_vars

5. **Update `molecule/default/verify.yml`**:
   - Verify git is installed: `git --version`
   - Verify git config is applied: `git config --global user.name`

**Dependencies**: None
**Installation Method**: Native APT package

---

### 9. gita 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Installs `gita` (git repository manager) using `uv tool install gita`
- Creates gita config directory
- Applies gita configuration template

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   - Verify uv is available via mise
   - Install gita using `uv tool install gita`
   - No additional dependencies needed (Python tool)

2. **Create `vars/Debian.yml`**:
   ```yaml
   gita_config_dir: "{{ ansible_env.HOME }}/.config/gita"
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - Ensure mise and uv roles run before gita

5. **Update `molecule/default/verify.yml`**:
   - Verify gita is in uv tool list
   - Test `gita --version` command
   - Verify config directory exists

**Dependencies**: mise, uv
**Installation Method**: uv tool install (Python package)

---

### 10. gpg 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Pure configuration role (no installation tasks)
- Creates GPG configuration directory (`~/.gnupg`)
- Applies gpg-agent configuration template
- Handler to reload GPG agent

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   ```yaml
   - name: Install GPG and dependencies via apt
     ansible.builtin.apt:
       name:
         - gnupg
         - gpg-agent
         - pinentry-curses
       state: present
       update_cache: true
     become: true
   ```

2. **Create `vars/Debian.yml`**:
   ```yaml
   gpg_packages:
     - gnupg
     - gpg-agent
     - pinentry-curses
   gpg_config_dir: "{{ ansible_env.HOME }}/.gnupg"
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - Set test GPG configuration in host_vars

5. **Update `molecule/default/verify.yml`**:
   - Verify GPG is installed: `gpg --version`
   - Verify gpg-agent config exists
   - Test GPG agent socket existence

**Dependencies**: None
**Installation Method**: Native APT packages

---

### 11. uv 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Configures uv shell integration
- Assumes uv is installed via mise
- Runs `uv tool update-shell` to update shell config

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   - No installation needed (uv installed via mise)
   - Configure shell integration via `uv tool update-shell`

2. **Create `vars/Debian.yml`**:
   ```yaml
   uv_shell_config_paths:
     - "{{ ansible_env.HOME }}/.bashrc"
     - "{{ ansible_env.HOME }}/.zshrc"
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - Ensure mise role runs before uv

5. **Update `molecule/default/verify.yml`**:
   - Verify uv is available: `mise which uv`
   - Verify shell configuration applied

**Dependencies**: mise
**Installation Method**: mise tool (installed via mise, role only configures)

---

### 12. vim 🔧

**Current Status**: No Linux support
**Complexity**: 🟢 LOW
**Molecule Tests**: Yes (`molecule/default/`)

**Current Behavior**:
- Pure configuration role (no installation tasks)
- Copies `.vimrc` configuration file to `~/.vimrc`
- Uses OS-specific group variable (`vim_group`)

**Debian Implementation Requirements**:

1. **Create `tasks/install-Debian.yml`**:
   ```yaml
   - name: Install vim via apt
     ansible.builtin.apt:
       name: vim
       state: present
       update_cache: true
     become: true
   ```

2. **Create `vars/Debian.yml`**:
   ```yaml
   vim_package: vim
   vim_group: "{{ ansible_user_id }}"
   ```

3. **Update `molecule/default/molecule.yml`**:
   - Add Debian 12 platform: `geerlingguy/docker-debian12-ansible`

4. **Update `molecule/default/converge.yml`**:
   - No special configuration needed

5. **Update `molecule/default/verify.yml`**:
   - Verify vim is installed: `vim --version`
   - Verify `.vimrc` file exists
   - Verify `.vimrc` has correct permissions

**Dependencies**: None
**Installation Method**: Native APT package

---

## macOS-Only Roles (No Debian Support Required)

These roles are explicitly platform-specific and exempt from Debian compatibility per constitution.

### 13. appstore 🍎

**Status**: macOS-only (Mac App Store automation)
**Justification**: Requires macOS App Store API, no Linux equivalent
**Constitution Exemption**: Platform-specific (section "Platform-Specific Exemptions")

---

### 14. iterm2 🍎

**Status**: macOS-only (Terminal emulator)
**Justification**: iTerm2 is macOS-exclusive application
**Constitution Exemption**: Platform-specific

---

### 15. macos_settings 🍎

**Status**: macOS-only (System preferences configuration)
**Justification**: Uses macOS-specific `defaults` command and system APIs
**Constitution Exemption**: Platform-specific

---

### 16. rosetta 🍎

**Status**: macOS-only (Rosetta 2 for Apple Silicon)
**Justification**: Rosetta 2 is Apple Silicon translation layer
**Constitution Exemption**: Platform-specific

---

## Implementation Priority Matrix

| Priority | Role | Complexity | Dependencies | Rationale |
|----------|------|------------|--------------|-----------|
| **P1** | git | 🟢 LOW | None | Foundation tool, zero dependencies |
| **P1** | vim | 🟢 LOW | None | Core editor, zero dependencies |
| **P1** | gpg | 🟢 LOW | None | Security tool, zero dependencies |
| **P2** | uv | 🟢 LOW | mise | Depends on mise (already Debian-compatible) |
| **P2** | copier | 🟢 LOW | mise, uv | Depends on uv (P2) |
| **P2** | gita | 🟢 LOW | mise, uv | Depends on uv (P2) |

### Implementation Strategy

**Phase 1 - Foundation (P1 roles)**:
1. git - Core version control
2. vim - Text editor
3. gpg - Security/encryption

**Phase 2 - Dependent Tools (P2 roles)**:
1. uv - Python package manager (depends on mise ✅)
2. copier - Template generator (depends on uv)
3. gita - Git repository manager (depends on uv)

**Rationale**: P1 roles have zero dependencies and can be implemented in parallel. P2 roles depend on mise (already Debian-compatible) and can be implemented once mise is validated on Debian 12.

## Package Mapping Reference

| Tool | Debian Package Name | Installation Method | Notes |
|------|-------------------|---------------------|-------|
| git | `git` | apt | Native Debian package |
| vim | `vim` | apt | Native Debian package |
| gnupg | `gnupg` | apt | Native Debian package |
| gpg-agent | `gpg-agent` | apt | Native Debian package |
| mise | `mise` | Third-party APT repo | Official mise repo |
| uv | N/A | mise tool | Installed via mise |
| copier | N/A | uv tool | Installed via uv |
| gita | N/A | uv tool | Installed via uv |

## Testing Checklist

For each role with Debian support, verify:

- [ ] `tasks/install-Debian.yml` created
- [ ] `vars/Debian.yml` created
- [ ] `molecule/default/molecule.yml` includes Debian 12 platform
- [ ] `molecule/default/converge.yml` updated with test configuration
- [ ] `molecule/default/verify.yml` updated with Debian-specific assertions
- [ ] `molecule test` passes on Debian 12 container
- [ ] Idempotency verified (changed=0 on second run)
- [ ] Role documented in README.md as Debian-compatible

## Next Phase

**Phase 2**: Generate `quickstart.md` with local Debian testing instructions and troubleshooting guide.
