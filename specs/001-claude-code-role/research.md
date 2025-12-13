# Research: Claude Code Installation Methods

**Date**: 2025-12-13
**Feature**: Claude Code Installation Role
**Branch**: 001-claude-code-role

## Overview

This document consolidates research findings on Claude Code installation methods across macOS, Ubuntu, and Debian platforms to inform the implementation of the Ansible role.

---

## 1. macOS Installation via Homebrew

### Decision: Use Homebrew Cask

**Package Name**: `claude-code`

**Installation Command**:
```bash
brew install --cask claude-code
```

**Repository**: Official Homebrew Cask repository (no custom tap required)

**Ansible Implementation**:
```yaml
- name: Install Claude Code via Homebrew
  community.general.homebrew_cask:
    name: claude-code
    state: present
```

### Rationale

- **Official distribution method**: Recommended by Claude Code documentation
- **Native Ansible module**: `community.general.homebrew_cask` provides idempotent installation
- **Auto-updates**: Homebrew-installed Claude Code auto-updates outside brew directory
- **Cross-architecture support**: Works on both Apple Silicon (ARM64) and Intel (x86_64)

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| curl script | Homebrew is the standard macOS package manager, already managed by base-tools role |
| npm installation | Requires Node.js dependency, larger footprint, not the primary installation method |
| Manual binary download | No update mechanism, harder to manage, not idempotent |

### Implementation Notes

- **Prerequisite**: Homebrew must be installed (handled by `base-tools` role dependency)
- **System Requirements**: macOS 10.15+ (Catalina and later)
- **Installation Location**: `/Applications/Claude.app` (standard Homebrew cask location)
- **Idempotency**: Homebrew cask module automatically handles "already installed" scenarios

---

## 2. Ubuntu/Debian Installation via curl

### Decision: Use Official curl Installation Script

**Installation Script URL**: `https://claude.ai/install.sh`

**Installation Command**:
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Binary Location**: `~/.local/bin/claude`

**Ansible Implementation**:
```yaml
- name: Check if Claude Code is already installed
  ansible.builtin.stat:
    path: "{{ ansible_env.HOME }}/.local/bin/claude"
  register: claude_binary

- name: Install Claude Code via curl
  ansible.builtin.shell:
    cmd: curl -fsSL https://claude.ai/install.sh | bash
  args:
    creates: "{{ ansible_env.HOME }}/.local/bin/claude"
  when: not claude_binary.stat.exists
```

### Rationale

- **Official installation method**: Recommended by Claude Code documentation
- **No Node.js dependency**: Native binary is self-contained
- **Idempotent with `creates:`**: Ansible won't re-run if binary already exists
- **User-space installation**: No root permissions required
- **Cross-architecture support**: Script detects and installs correct binary (x86_64 or ARM64)

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| npm installation | Requires Node.js 18+, larger footprint, not the primary method |
| Manual binary download | No auto-update mechanism, harder to manage versions |
| Debian package (.deb) | No official .deb package available from Anthropic |

### Implementation Notes

- **Prerequisite**: curl must be available (typically pre-installed on Ubuntu/Debian)
- **System Requirements**: Ubuntu 20.04+ or Debian 10+, 4 GB+ RAM minimum
- **Binary Path**: `~/.local/bin/claude` (user's local bin directory)
- **Data Directory**: `~/.claude-code/` (created automatically)
- **Idempotency Strategy**: Use `ansible.builtin.stat` to check if binary exists, use `creates:` parameter
- **Internet Requirement**: Installation requires internet connectivity

---

## 3. Version Verification and Validation

### Decision: Verify Installation with `claude --version`

**Verification Command**:
```bash
claude --version
```

**Expected Output**: Version number (e.g., `2.0.69`)

**Ansible Verification**:
```yaml
- name: Verify Claude Code installation
  ansible.builtin.command:
    cmd: claude --version
  register: claude_version
  changed_when: false
  failed_when: claude_version.rc != 0
```

### Rationale

- **Simple validation**: `--version` flag is universally supported
- **Non-invasive**: Doesn't modify system state
- **Molecule-testable**: Can be run in containers to validate installation
- **Clear failure**: Returns non-zero exit code if not installed

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| `claude doctor` | May require authentication, not suitable for automated testing |
| `which claude` | Only checks PATH existence, doesn't verify binary functionality |
| File existence check | Doesn't validate that binary is executable or correct version |

---

## 4. Idempotency Strategy

### Decision: Use Ansible Module Features + Conditional Checks

**macOS (Homebrew)**:
- `community.general.homebrew_cask` module is inherently idempotent
- Module checks if cask is already installed before attempting installation
- No additional logic required

**Ubuntu/Debian (curl script)**:
- Use `ansible.builtin.stat` to check if binary exists
- Use `creates:` parameter with `ansible.builtin.shell` to prevent re-execution
- Combine both approaches for defense-in-depth

### Rationale

- **Constitution requirement**: Idempotency is non-negotiable
- **Performance optimization**: Avoid unnecessary network calls and re-downloads
- **Molecule testing**: Second run must show `changed=0`

### Implementation Pattern

```yaml
# Check before installing
- name: Check if Claude Code binary exists
  ansible.builtin.stat:
    path: "{{ claude_code_binary_path }}"
  register: claude_binary

# Install only if not exists
- name: Install Claude Code
  ansible.builtin.shell:
    cmd: "{{ install_command }}"
  args:
    creates: "{{ claude_code_binary_path }}"
  when: not claude_binary.stat.exists
```

---

## 5. Auto-Update Behavior

### Decision: Leave Auto-Updates Enabled (Default)

**Default Behavior**: Claude Code auto-updates by default for all installation methods

**Auto-Update Mechanism**:
- Updates happen automatically in the background
- No manual intervention required
- Works for both Homebrew and native binary installations

### Rationale

- **Security**: Users get latest security patches automatically
- **Features**: Users benefit from new features without manual updates
- **Maintenance**: Reduces support burden (users stay on current versions)
- **Consistency**: Matches other auto-updating tools in the playbook (e.g., VS Code, Cursor)

### Future Enhancement (Out of Scope)

If users request disabling auto-updates, can add optional variable:
```yaml
claude_code_disable_autoupdate: false  # Default keeps auto-updates enabled
```

Implementation would set environment variable or update settings.json, but this is not required for MVP.

---

## 6. Molecule Testing Strategy

### Decision: Test on Ubuntu 24.04 and Debian 12 Containers

**Test Platforms**:
- Ubuntu 24.04: `geerlingguy/docker-ubuntu2404-ansible`
- Debian 12: `geerlingguy/docker-debian12-ansible`

**Test Scenarios**:

1. **Convergence Test**: Role runs without errors
2. **Idempotency Test**: Second run shows `changed=0`
3. **Verification Test**: Binary exists at expected location and is executable

**Molecule Configuration**:
```yaml
platforms:
  - name: ubuntu2404
    image: geerlingguy/docker-ubuntu2404-ansible
    pre_build_image: true
  - name: debian12
    image: geerlingguy/docker-debian12-ansible
    pre_build_image: true
```

**Verification Tasks**:
```yaml
- name: Check Claude Code binary exists
  ansible.builtin.stat:
    path: "{{ ansible_env.HOME }}/.local/bin/claude"
  register: result
  failed_when: not result.stat.exists

- name: Check Claude Code is executable
  ansible.builtin.command:
    cmd: "{{ ansible_env.HOME }}/.local/bin/claude --version"
  changed_when: false
```

### Rationale

- **Constitution requirement**: Test-first via Molecule is mandatory
- **Platform coverage**: Tests both major Debian-based distributions
- **CI integration**: Automated testing in GitHub Actions prevents regressions
- **macOS exemption**: macOS-specific code tested manually (constitution allows this)

---

## 7. Feature Flag Implementation

### Decision: Use `claude_code_enabled` Boolean Variable

**Default Value**: `true` (install by default)

**Variable Location**:
- **Default**: `roles/claude-code/defaults/main.yml`
- **User Override**: `group_vars/all.yml` (optional)

**Implementation**:
```yaml
# defaults/main.yml
claude_code_enabled: true

# tasks/main.yml
- name: Include OS-specific installation tasks
  ansible.builtin.include_tasks: "install-{{ ansible_facts.os_family }}.yml"
  when: claude_code_enabled | bool
  tags: ["claude-code"]
```

### Rationale

- **Constitution requirement**: Single source configuration in group_vars/all.yml
- **Naming convention**: Follows `<role>_enabled` pattern from other roles
- **User control**: Users can disable installation by setting `claude_code_enabled: false`
- **Sensible default**: Most users want the tool installed (enabled by default)

---

## 8. Dependency Management

### Decision: Depend on `base-tools` Role for Homebrew

**Role Dependency** (meta/main.yml):
```yaml
dependencies:
  - role: base-tools
    when: ansible_facts.os_family == 'Darwin'
```

### Rationale

- **Homebrew prerequisite**: macOS installation requires Homebrew to be installed first
- **Existing pattern**: Other roles (cursor, zsh) already depend on base-tools
- **Avoid duplication**: Don't re-implement Homebrew installation logic
- **Conditional dependency**: Only required on macOS, not Ubuntu/Debian

### Ubuntu/Debian Prerequisites

- **curl**: Assumed to be pre-installed (standard on modern Ubuntu/Debian)
- **No additional dependencies**: curl script is self-contained

---

## 9. Error Handling and Retry Logic

### Decision: Homebrew Check + Retry Logic for curl

**Updated from Clarification Session 2025-12-13**

**macOS - Homebrew Presence Check (FR-011)**:
```yaml
- name: Check if Homebrew is installed
  ansible.builtin.stat:
    path: /opt/homebrew/bin/brew  # Apple Silicon
  register: homebrew_arm

- name: Check if Homebrew is installed (Intel)
  ansible.builtin.stat:
    path: /usr/local/bin/brew
  register: homebrew_intel

- name: Fail if Homebrew is not installed
  ansible.builtin.fail:
    msg: "Homebrew is not installed. Please ensure the base-tools role has run first or install Homebrew manually."
  when: not (homebrew_arm.stat.exists or homebrew_intel.stat.exists)
```

**Ubuntu/Debian - Retry Logic (FR-012)**:
```yaml
- name: Install Claude Code via curl with retries
  ansible.builtin.shell:
    cmd: curl -fsSL https://claude.ai/install.sh | bash
  args:
    creates: "{{ claude_code_binary_path }}"
  register: curl_install_result
  retries: 3
  delay: 5
  until: curl_install_result.rc == 0
  when: not claude_binary.stat.exists
```

### Rationale

- **Explicit Homebrew check**: Prevents cryptic failures when Homebrew is missing (Clarification Q1)
- **Retry on network failures**: Handles transient network issues gracefully (Clarification Q3)
- **Clear error messages**: Directs users to fix prerequisite issues
- **3 retries with 5-second delay**: Balances reliability with reasonable timeout

### Version Update Behavior (Clarification Q2)

**Decision**: Preserve existing versions (no forced updates)

```yaml
# Homebrew cask with state: present (not latest)
- name: Install Claude Code via Homebrew
  community.general.homebrew_cask:
    name: claude-code
    state: present  # NOT 'latest' - preserves existing version
```

**Rationale**:
- Claude Code has built-in auto-update mechanism
- Idempotency requirement: don't force version changes
- Users control when to update (via Claude Code's auto-updater)

### OS Version Compatibility (Clarification Q4)

**Decision**: No explicit version checks - let installation tools fail naturally

**Rationale**:
- Homebrew and curl script have their own OS version checks
- Avoid duplicating version logic
- Users get native error messages from installation tools
- Simplicity: don't add unnecessary validation

### Download Integrity (Clarification Q5)

**Decision**: Trust HTTPS/TLS without additional verification

```yaml
# Use -fsSL flags: follow redirects, silent, show errors, location-aware
curl -fsSL https://claude.ai/install.sh | bash
```

**Rationale**:
- HTTPS/TLS provides transport security
- Standard practice for `curl | bash` installations
- No official checksums or GPG signatures published by Anthropic
- Simplicity: avoid checksum maintenance overhead

---

## Summary of Key Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| **macOS Installation** | Homebrew cask (`claude-code`) | Official method, idempotent module, auto-updates |
| **Ubuntu/Debian Installation** | curl script (`claude.ai/install.sh`) | Official method, no Node.js dependency, self-contained |
| **Idempotency** | Module features + `creates:` + `stat` checks | Constitution requirement, defense-in-depth |
| **Version Updates** | Preserve existing (no forced updates) | Claude Code self-updates, idempotency requirement |
| **Homebrew Check** | Explicit verification before installation | Clear error messages, fail fast (FR-011) |
| **Retry Logic** | 3 retries with 5-second delay for curl | Handle transient network failures (FR-012) |
| **OS Version Check** | None - let tools fail naturally | Avoid duplication, simplicity |
| **Download Integrity** | Trust HTTPS/TLS only | Standard practice, no official checksums |
| **Testing** | Molecule on Ubuntu 24.04 + Debian 12 | Constitution requirement, CI integration |
| **Feature Flag** | `claude_code_enabled: true` (default) | Single source config, user control |
| **Dependencies** | base-tools (macOS only) | Existing pattern, Homebrew prerequisite |
| **Auto-Updates** | Leave enabled (default) | Security, features, low maintenance |
| **Verification** | `claude --version` | Simple, non-invasive, testable |

---

## Implementation Readiness

All research questions from the Technical Context have been resolved. The role is ready for Phase 1 (Design & Contracts).

**Next Steps**:
- Phase 1: Generate data-model.md (role variables and configuration)
- Phase 1: Generate quickstart.md (developer getting started guide)
- Phase 1: Update agent context with technologies used
