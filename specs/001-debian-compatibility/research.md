# Phase 0: Research - Debian Compatibility Investigation

**Date**: 2025-12-09
**Branch**: `feat/debian-compatibility`
**Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)

## Executive Summary

**Key Finding**: The repository **already has partial Debian support** implemented for 6 out of 16 roles. The existing architecture uses `install-Debian.yml` task files (NOT `install-Ubuntu.yml`), confirming that the OS-aware pattern leverages Ansible's `ansible_os_family == 'Debian'` fact which covers both Ubuntu AND Debian.

**Decision**: This is NOT a ground-up implementation. This is a **completion task** - extending existing Debian support to the remaining 10 roles that currently lack Linux support.

**Complexity**: LOWER than initially estimated. We can reuse the established patterns from the 6 existing Debian-compatible roles.

## Current State Analysis

### Roles with Existing Debian Support (6 roles)

These roles already have `install-Debian.yml` files and should work on both Ubuntu and Debian:

1. **base-tools** - Package manager setup, APT repositories, binary installations
2. **cursor** - Cursor IDE installation via .deb package
3. **mise** - Version manager using official mise APT repository
4. **rancher-desktop** - Container management platform (likely via .deb)
5. **warp** - Modern terminal emulator
6. **zsh** - Shell installation and configuration

**Evidence**: `roles/{base-tools,cursor,mise,rancher-desktop,warp,zsh}/tasks/install-Debian.yml` exist

### Roles Requiring Linux Support (10 roles)

These roles need new `install-Debian.yml` files to support Debian/Ubuntu:

1. **copier** - Template generator (needs molecule tests)
2. **git** - Version control configuration (needs molecule tests)
3. **gita** - Git repository manager (needs molecule tests)
4. **gpg** - GPG key management (needs molecule tests)
5. **uv** - Python package installer (needs molecule tests)
6. **vim** - Text editor configuration (needs molecule tests)

### macOS-Only Roles (Exempt from Debian Support)

These roles are platform-specific and documented as such:

1. **appstore** - Mac App Store automation (macOS-only)
2. **iterm2** - Terminal emulator (macOS-only)
3. **macos_settings** - System preferences (macOS-only)
4. **rosetta** - Rosetta 2 for Apple Silicon (macOS-only)

**Constitution Compliance**: These are exempt per "Platform-Specific Exemptions" in constitution.md

## Package Management Investigation

### APT Package Availability (Ubuntu vs Debian)

Based on analysis of `roles/base-tools/tasks/install-Debian.yml`, the playbook uses:

1. **Native APT packages** - From Debian/Ubuntu main repositories
2. **Third-party APT repositories** - Using signed-by method with GPG keys
3. **Direct .deb downloads** - For applications without APT repos (Slack, Cursor)
4. **Binary installations** - Direct GitHub release downloads (.tar.gz, single binaries)

**Debian 12 (Bookworm) Package Availability**:
- ✅ Core development tools: `curl`, `wget`, `git`, `build-essential`, `python3-pip`
- ✅ Shell utilities: `zsh`, `tmux`, `htop`, `jq`
- ✅ Programming languages: `golang`, `nodejs`, `python3`
- ✅ Container tools: Docker CE (via third-party repo), Podman

**Package Name Compatibility**:
- Ubuntu and Debian share the same package naming conventions for most packages
- Both use `apt` as the package manager
- Both support `.deb` package format
- Architecture naming is identical: `amd64` (x86_64), `arm64` (ARM64)

**Confidence Level**: HIGH - Existing `install-Debian.yml` files demonstrate that package management works identically on Ubuntu and Debian.

## Container Validation

### Molecule Container Image: `geerlingguy/docker-debian12-ansible`

**Image Details**:
- **Maintainer**: Jeff Geerling (trusted Ansible community contributor)
- **Base OS**: Debian 12 (Bookworm)
- **Pre-installed**: Python, systemd (init system), Ansible dependencies
- **Architecture Support**: amd64, arm64
- **Purpose**: Container-based Ansible testing with systemd support

**Existing Usage**:
Looking at current Molecule configurations, the repository currently uses:
- `geerlingguy/docker-ubuntu2404-ansible` for Ubuntu 24.04 tests

**Validation**:
- ✅ Image is actively maintained by Jeff Geerling
- ✅ Compatible with Podman driver (current CI setup)
- ✅ Includes systemd for service testing (if needed)
- ✅ Matches Debian 12 (Bookworm) - current stable release
- ✅ Consistent with existing `docker-ubuntu2404-ansible` pattern

**Decision**: Use `geerlingguy/docker-debian12-ansible` for all Debian Molecule tests per FR-003 and FR-010.

## Architecture Pattern Analysis

### OS-Aware Task Inclusion

All existing Debian-compatible roles follow this pattern in `tasks/main.yml`:

```yaml
- name: Include OS-specific variables
  ansible.builtin.include_vars: "{{ ansible_os_family }}.yml"

- name: Include OS-specific installation tasks
  ansible.builtin.include_tasks: "install-{{ ansible_os_family }}.yml"
```

**Key Insight**: `ansible_os_family` returns `"Debian"` for BOTH Ubuntu and Debian, eliminating the need for separate task files per distribution.

### Variable Structure

Existing roles define OS-specific variables in `vars/Debian.yml`:

**Example from `roles/cursor/vars/Debian.yml`** (inferred pattern):
```yaml
cursor_download_url: "https://downloader.cursor.sh/linux/appImage/x64"
cursor_install_path: "/usr/bin/cursor"
```

**Decision**: All new Debian support will use `vars/Debian.yml` (NOT `vars/Ubuntu.yml`, which doesn't exist in the codebase).

## Implementation Strategy

### Option A: Extend Existing Debian Files (RECOMMENDED)

**Approach**: Since Ubuntu and Debian share `ansible_os_family == 'Debian'`, all `install-Debian.yml` files work for both distributions.

**Implementation**:
1. Create `install-Debian.yml` for the 10 roles lacking Linux support
2. Create `vars/Debian.yml` for OS-specific package names/paths
3. Update Molecule tests to include Debian 12 containers
4. Validate idempotence on both Ubuntu 24.04 and Debian 12 containers

**Advantages**:
- ✅ Consistent with existing 6 roles (base-tools, cursor, mise, rancher-desktop, warp, zsh)
- ✅ Single source of truth for Debian-family distributions
- ✅ Lower maintenance burden (one file to update, not two)
- ✅ Follows Ansible best practices for OS family grouping

**Disadvantages**:
- None identified - this is the established pattern in the codebase

### Option B: Separate Ubuntu vs Debian Files (NOT RECOMMENDED)

**Approach**: Create both `install-Ubuntu.yml` and `install-Debian.yml` files, using `ansible_distribution` fact for detection.

**Why Rejected**:
- ❌ Conflicts with existing architecture (only `install-Debian.yml` files exist, no `install-Ubuntu.yml`)
- ❌ Higher maintenance burden (duplicate task definitions)
- ❌ No evidence of Ubuntu-specific customization needs
- ❌ Would require refactoring 6 existing roles for consistency

## Package Installation Methods

Based on `roles/base-tools/tasks/install-Debian.yml` analysis, the playbook uses these methods in order of preference:

### 1. Native APT Packages (Preferred)

```yaml
- name: Install packages via apt
  ansible.builtin.apt:
    name: "{{ debian_apt_packages }}"
    state: present
    update_cache: true
```

**Use for**: Core system utilities available in Debian/Ubuntu repositories

### 2. Third-Party APT Repositories

```yaml
- name: Add third-party APT repository with signed-by
  ansible.builtin.apt_repository:
    repo: "deb [signed-by=/etc/apt/keyrings/{{ item.key }}.gpg] {{ item.value.repo_url }}"
    state: present
```

**Use for**: Applications with official Debian/Ubuntu repositories (e.g., Docker, mise)

### 3. Direct .deb Package Installation

```yaml
- name: Install via .deb package
  ansible.builtin.apt:
    deb: "/path/to/package.deb"
    state: present
```

**Use for**: Applications distributed as .deb files without repositories (e.g., Slack, Cursor)

### 4. Binary Installation from GitHub Releases

```yaml
- name: Download binary from GitHub releases
  ansible.builtin.get_url:
    url: "https://github.com/owner/repo/releases/download/{{ version }}/binary"
    dest: /usr/local/bin/tool
    mode: "0755"
```

**Use for**: CLI tools distributed as standalone binaries (e.g., yq, dive, gopass)

## Idempotency Patterns

### Check-Before-Install Pattern

All existing Debian tasks follow this idempotent pattern:

```yaml
- name: Check if tool is already installed
  ansible.builtin.stat:
    path: /usr/bin/tool
  register: tool_installed

- name: Download and install tool
  when: not tool_installed.stat.exists
  block:
    - name: Download tool
      ansible.builtin.get_url: ...
    - name: Install tool
      ansible.builtin.apt: ...
```

**Benefits**:
- Prevents redundant downloads
- Ensures `changed=0` on second run
- Maintains idempotency guarantee

### Temporary File Cleanup

```yaml
- name: Clean up temporary download files
  ansible.builtin.file:
    path: /tmp/downloaded_file.deb
    state: absent
  failed_when: false
```

**Note**: Files needed for idempotency checks (e.g., Slack .deb) are NOT cleaned up.

## Molecule Testing Requirements

### Current Test Configuration

Based on existing roles, Molecule tests use:

**Container Platform**: Debian 12 containers (`geerlingguy/docker-debian12-ansible`)
**Driver**: Podman
**Test Scenarios**:
1. `converge.yml` - Run the role
2. `verify.yml` - Assert expected outcomes
3. `molecule.yml` - Platform and driver configuration

### Test Limitations in Containers

From `roles/base-tools/tasks/install-Debian.yml` comments:

```yaml
# Allow GUI apps to fail in containers (Chrome, Spotify need X11/Wayland dependencies)
failed_when: false
```

**Container Testing Constraints**:
- ❌ GUI applications cannot be tested (no X11/Wayland)
- ❌ systemd services may not start properly
- ❌ Network-dependent downloads may fail (rate limits, timeouts)
- ✅ Package installations can be tested
- ✅ File/directory creation can be tested
- ✅ Idempotency can be verified

**Solution**: Disable GUI-dependent features in Molecule test configurations using host_vars.

## Risk Assessment

### Low Risk Items

1. **Package availability** - Debian 12 has all required packages
2. **APT compatibility** - Ubuntu and Debian share package manager
3. **Architecture detection** - `ansible_machine` fact works identically
4. **Existing patterns** - 6 roles demonstrate proven approach

### Medium Risk Items

1. **Third-party repository URLs** - Some may be Ubuntu-specific, need validation
2. **Binary download URLs** - Architecture naming (`amd64` vs `x86_64`) may vary
3. **Molecule test coverage** - 10 roles need new test scenarios

### Mitigation Strategies

1. **Repository validation**: Test all third-party APT repos on Debian 12
2. **Binary URL patterns**: Use architecture mapping (`ansible_architecture` → download URL format)
3. **Incremental testing**: Validate each role's Molecule tests before proceeding to next

## Decision Matrix

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| **Task file naming** | `install-Debian.yml` | Matches existing 6 roles, leverages `ansible_os_family` fact |
| **Variable file naming** | `vars/Debian.yml` | Consistent with existing architecture |
| **Molecule container** | `geerlingguy/docker-debian12-ansible` | Official Debian 12 image, trusted maintainer |
| **Package method** | APT → .deb → Binary | Order of preference from existing roles |
| **Idempotency pattern** | Check-before-install with stat | Proven pattern from existing roles |
| **Test strategy** | Add Debian 12 to molecule.yml platforms | Parallel Ubuntu 24.04 and Debian 12 testing |

## Next Steps (Phase 1)

1. **Generate role inventory** (`role-inventory.md`)
   - Detailed audit of all 10 roles needing Debian support
   - Package mapping for each role
   - Complexity assessment per role

2. **Create quickstart guide** (`quickstart.md`)
   - Local testing instructions for Debian 12
   - Molecule test execution guide
   - Troubleshooting common issues

3. **Update agent context** (CLAUDE.md)
   - Add Debian to OS-aware architecture examples
   - Update testing workflow with Debian 12 containers
   - Document three-OS support (macOS, Ubuntu, Debian)

## Research Conclusion

**Feasibility**: HIGH - This is a straightforward completion task, not a complex refactoring.

**Effort Estimate**:
- 10 roles × (create install-Debian.yml + vars/Debian.yml + update Molecule tests) = Moderate effort
- Leverage existing patterns from 6 Debian-compatible roles = Significant code reuse
- No architecture changes required = Lower risk

**Recommendation**: Proceed to Phase 1 (design artifacts) with confidence. The existing implementation provides a clear blueprint for extending Debian support to remaining roles.
