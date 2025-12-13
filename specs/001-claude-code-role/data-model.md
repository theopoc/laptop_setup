# Data Model: Claude Code Installation Role

**Date**: 2025-12-13
**Feature**: Claude Code Installation Role
**Branch**: 001-claude-code-role

## Overview

This document defines the data structures (variables, facts, and configuration) used by the Claude Code installation role. Since this is an Ansible role, the "data model" consists of Ansible variables, facts, and their relationships.

---

## 1. Role Variables

### 1.1 User-Configurable Variables (defaults/main.yml)

These variables can be overridden by users in `group_vars/all.yml`.

| Variable Name | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `claude_code_enabled` | Boolean | `true` | Controls whether Claude Code should be installed. Set to `false` to skip installation. |

**Example Override** (group_vars/all.yml):
```yaml
# Disable Claude Code installation
claude_code_enabled: false
```

**Validation Rules**:
- Must be a boolean value (`true` or `false`)
- Used with `when` conditional in tasks
- Follows naming convention: `<role>_enabled` suffix

---

### 1.2 OS-Specific Variables

These variables are defined per operating system family and loaded dynamically based on `ansible_facts.os_family`.

#### vars/Darwin.yml (macOS)

| Variable Name | Type | Value | Description |
|--------------|------|-------|-------------|
| `claude_code_package_name` | String | `claude-code` | Homebrew cask name for Claude Code |
| `claude_code_package_manager` | String | `homebrew_cask` | Package manager to use on macOS |

**Example**:
```yaml
---
# macOS-specific variables
claude_code_package_name: claude-code
claude_code_package_manager: homebrew_cask
```

#### vars/Debian.yml (Ubuntu/Debian)

| Variable Name | Type | Value | Description |
|--------------|------|-------|-------------|
| `claude_code_install_script_url` | String | `https://claude.ai/install.sh` | URL of the official installation script |
| `claude_code_binary_path` | String | `{{ ansible_env.HOME }}/.local/bin/claude` | Expected location of installed binary |
| `claude_code_data_directory` | String | `{{ ansible_env.HOME }}/.claude-code` | Data directory created by installation |

**Example**:
```yaml
---
# Ubuntu/Debian-specific variables
claude_code_install_script_url: https://claude.ai/install.sh
claude_code_binary_path: "{{ ansible_env.HOME }}/.local/bin/claude"
claude_code_data_directory: "{{ ansible_env.HOME }}/.claude-code"
```

---

## 2. Ansible Facts Used

The role relies on Ansible's built-in facts for OS detection and user context.

| Fact Name | Purpose | Example Values |
|-----------|---------|----------------|
| `ansible_facts.os_family` | Determine which installation method to use | `Darwin` (macOS), `Debian` (Ubuntu/Debian) |
| `ansible_facts.distribution` | Fine-grained OS detection (future use) | `Ubuntu`, `Debian`, `MacOSX` |
| `ansible_facts.architecture` | CPU architecture (informational) | `x86_64`, `arm64` |
| `ansible_env.HOME` | User's home directory for binary path | `/home/username`, `/Users/username` |

**Usage Example**:
```yaml
- name: Include OS-specific variables
  ansible.builtin.include_vars: "{{ ansible_facts.os_family }}.yml"

- name: Include OS-specific installation tasks
  ansible.builtin.include_tasks: "install-{{ ansible_facts.os_family }}.yml"
```

---

## 3. Registered Variables (Runtime State)

These variables capture runtime state during task execution.

| Variable Name | Registered By | Type | Purpose |
|--------------|---------------|------|---------|
| `claude_binary` | `ansible.builtin.stat` | Stat result | Check if Claude Code binary already exists (idempotency) |
| `claude_version` | `ansible.builtin.command` | Command result | Capture version output for verification |
| `homebrew_cask_result` | `community.general.homebrew_cask` | Module result | Capture Homebrew installation result (macOS) |
| `curl_install_result` | `ansible.builtin.shell` | Command result | Capture curl installation result (Ubuntu/Debian) |

**Example Usage**:
```yaml
- name: Check if Claude Code is already installed
  ansible.builtin.stat:
    path: "{{ claude_code_binary_path }}"
  register: claude_binary

- name: Install Claude Code via curl
  ansible.builtin.shell:
    cmd: curl -fsSL {{ claude_code_install_script_url }} | bash
  args:
    creates: "{{ claude_code_binary_path }}"
  when: not claude_binary.stat.exists
  register: curl_install_result
```

---

## 4. Role Dependencies (meta/main.yml)

| Dependency | Condition | Purpose |
|------------|-----------|---------|
| `base-tools` | `ansible_facts.os_family == 'Darwin'` | Ensures Homebrew is installed on macOS before installing Claude Code |

**meta/main.yml**:
```yaml
---
dependencies:
  - role: base-tools
    when: ansible_facts.os_family == 'Darwin'
```

---

## 5. Data Flow Diagram

```text
┌─────────────────────────────────────┐
│  User Configuration                 │
│  (group_vars/all.yml)              │
│                                     │
│  claude_code_enabled: true         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Role Defaults                      │
│  (defaults/main.yml)               │
│                                     │
│  claude_code_enabled: true         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Main Task                          │
│  (tasks/main.yml)                  │
│                                     │
│  1. Load OS-specific vars          │
│  2. Include OS-specific tasks      │
└──────────────┬──────────────────────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
┌──────────────┐  ┌──────────────┐
│  Darwin      │  │  Debian      │
│  (vars/)     │  │  (vars/)     │
└──────┬───────┘  └──────┬───────┘
       │                 │
       ▼                 ▼
┌──────────────┐  ┌──────────────┐
│ install-     │  │ install-     │
│ Darwin.yml   │  │ Debian.yml   │
│              │  │              │
│ Homebrew     │  │ curl script  │
│ installation │  │ installation │
└──────┬───────┘  └──────┬───────┘
       │                 │
       └────────┬────────┘
                ▼
       ┌─────────────────┐
       │  Verification   │
       │  claude --version│
       └─────────────────┘
```

---

## 6. Molecule Test Variables (molecule.yml)

Test-specific variable overrides for container environments.

| Variable Name | Test Value | Purpose |
|--------------|------------|---------|
| `claude_code_enabled` | `true` | Enable installation in tests |
| `ansible_env.HOME` | Container user home | Override HOME for container environment |

**molecule.yml provisioner.inventory.host_vars**:
```yaml
provisioner:
  inventory:
    host_vars:
      ubuntu2404:
        claude_code_enabled: true
      debian12:
        claude_code_enabled: true
```

---

## 7. State Transitions

The role manages the following state transitions:

```text
┌─────────────────┐
│  Initial State  │
│  (No Claude)    │
└────────┬────────┘
         │
         ▼
    ┌─────────┐
    │ Check   │◄─────────┐
    │ if      │          │
    │ exists  │          │
    └────┬────┘          │
         │               │
    ┌────┴────┐          │
    │ Exists? │          │
    └────┬────┘          │
         │               │
    ┌────┴────┐          │
    │   No    │          │
    └────┬────┘          │
         │               │
         ▼               │
┌─────────────────┐      │
│   Download &    │      │
│   Install       │      │
└────────┬────────┘      │
         │               │
         ▼               │
┌─────────────────┐      │
│   Installed     │      │
│   State         │──────┘
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   Verify        │
│   (--version)   │
└─────────────────┘
```

**Idempotency**: If Claude Code is already installed (exists check passes), the role skips installation and proceeds directly to verification, resulting in `changed=0`.

---

## 8. Configuration Files (Not Managed by Role)

The role does NOT manage Claude Code configuration files. These are created and managed by Claude Code itself:

| File/Directory | Location | Purpose |
|---------------|----------|---------|
| `.claude-code/` | `~/.claude-code/` | Data directory (auto-created by Claude Code) |
| `settings.json` | User-defined | Optional settings (not managed by role) |
| `.claude.json` | Project-level | Project-specific config (not managed by role) |
| `.mcp.json` | Project-level | MCP server config (not managed by role) |

**Rationale**: The role only handles installation, not configuration. Configuration management would be a future enhancement if requested by users.

---

## 9. Variable Naming Conventions

All variables follow the repository's naming conventions from the constitution:

| Convention | Example | Compliance |
|-----------|---------|------------|
| Role prefix | `claude_code_*` | ✅ All variables prefixed |
| Boolean suffix | `claude_code_enabled` | ✅ Uses `_enabled` suffix |
| OS-specific separation | `vars/Darwin.yml`, `vars/Debian.yml` | ✅ Separated by OS family |
| Default location | `defaults/main.yml` | ✅ Defaults in correct location |
| User override location | `group_vars/all.yml` | ✅ Single source of truth |

---

## 10. Data Validation

### Variable Validation Rules

| Variable | Validation | Error Behavior |
|----------|-----------|----------------|
| `claude_code_enabled` | Must be boolean | Task skipped if not boolean (Ansible handles) |
| `claude_code_install_script_url` | Must be valid URL | curl will fail if invalid, task fails |
| `claude_code_binary_path` | Must be absolute path | Installation succeeds but verification fails if wrong |

**Validation Strategy**: Rely on Ansible's type checking and task failures rather than explicit validation tasks (follows Simplicity principle).

---

## Summary

The data model for the Claude Code installation role is minimal and focused:

- **1 user-configurable variable**: `claude_code_enabled`
- **5 OS-specific variables**: Package names, URLs, paths
- **4 Ansible facts**: OS detection and user context
- **4 registered variables**: Runtime state for idempotency and verification
- **1 role dependency**: base-tools (macOS only)

This minimalist approach follows the constitution's Simplicity principle (YAGNI) - only include variables needed for actual requirements, avoid over-engineering.
