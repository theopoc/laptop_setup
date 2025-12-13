# Quickstart Guide: Claude Code Installation Role

**Date**: 2025-12-13
**Feature**: Claude Code Installation Role
**Branch**: 001-claude-code-role

## Overview

This guide helps developers implement and test the Claude Code installation role following the repository's architecture patterns and constitution requirements.

---

## Prerequisites

Before you begin, ensure you have:

- [x] Ansible 2.15+ installed
- [x] Podman installed (for Molecule testing)
- [x] molecule[podman] Python package installed
- [x] Access to the `001-claude-code-role` branch
- [x] Familiarity with Ansible role structure
- [x] Read `research.md` and `data-model.md` in this directory

**Install dependencies**:
```bash
# Install Ansible and Molecule
pip install ansible molecule[podman] ansible-lint

# Verify installations
ansible --version
molecule --version
podman --version
```

---

## Step 1: Create Role Directory Structure

Create the role skeleton following the repository's OS-aware architecture pattern:

```bash
cd roles
mkdir -p claude-code/{defaults,tasks,vars,meta,molecule/default}
```

**Expected structure**:
```text
roles/claude-code/
├── defaults/
├── tasks/
├── vars/
├── meta/
└── molecule/
    └── default/
```

---

## Step 2: Create Default Variables

**File**: `roles/claude-code/defaults/main.yml`

```yaml
---
# Default variables for claude-code role
# Users can override these in group_vars/all.yml

# Enable/disable Claude Code installation
claude_code_enabled: true
```

**Why**: Establishes the feature flag that users can toggle to control installation. Default is `true` so Claude Code installs by default.

---

## Step 3: Create OS-Specific Variables

### macOS Variables

**File**: `roles/claude-code/vars/Darwin.yml`

```yaml
---
# macOS-specific variables

# Homebrew cask name for Claude Code
claude_code_package_name: claude-code

# Package manager to use
claude_code_package_manager: homebrew_cask
```

### Ubuntu/Debian Variables

**File**: `roles/claude-code/vars/Debian.yml`

```yaml
---
# Ubuntu/Debian-specific variables

# Official Claude Code installation script URL
claude_code_install_script_url: https://claude.ai/install.sh

# Expected binary installation path
claude_code_binary_path: "{{ ansible_env.HOME }}/.local/bin/claude"

# Data directory created by installation
claude_code_data_directory: "{{ ansible_env.HOME }}/.claude-code"
```

**Why**: Separates OS-specific values, making it easy to update installation methods per platform without touching task logic.

---

## Step 4: Create Role Dependencies

**File**: `roles/claude-code/meta/main.yml`

```yaml
---
# Role dependencies

dependencies:
  # Homebrew is required on macOS for installation
  - role: base-tools
    when: ansible_facts.os_family == 'Darwin'
```

**Why**: Ensures Homebrew is installed on macOS before attempting to install Claude Code. Follows existing pattern from other roles.

---

## Step 5: Create Main Task File

**File**: `roles/claude-code/tasks/main.yml`

```yaml
---
# Main task file for claude-code role

- name: Include OS-specific variables
  ansible.builtin.include_vars: "{{ ansible_facts.os_family }}.yml"
  when: claude_code_enabled | bool
  tags: ["claude-code"]

- name: Include OS-specific installation tasks
  ansible.builtin.include_tasks: "install-{{ ansible_facts.os_family }}.yml"
  when: claude_code_enabled | bool
  tags: ["claude-code"]
```

**Why**: Follows the orchestrator pattern - main.yml detects OS and delegates to OS-specific task files. Respects the feature flag.

---

## Step 6: Create macOS Installation Tasks

**File**: `roles/claude-code/tasks/install-Darwin.yml`

```yaml
---
# macOS installation tasks

- name: Install Claude Code via Homebrew cask
  community.general.homebrew_cask:
    name: "{{ claude_code_package_name }}"
    state: present
  tags: ["claude-code"]

- name: Verify Claude Code installation (macOS)
  ansible.builtin.command:
    cmd: claude --version
  register: claude_version
  changed_when: false
  failed_when: claude_version.rc != 0
  tags: ["claude-code"]
```

**Why**: Uses native Homebrew module for idempotent installation. Verification ensures installation succeeded.

---

## Step 7: Create Ubuntu/Debian Installation Tasks

**File**: `roles/claude-code/tasks/install-Debian.yml`

```yaml
---
# Ubuntu/Debian installation tasks

- name: Check if Claude Code binary already exists
  ansible.builtin.stat:
    path: "{{ claude_code_binary_path }}"
  register: claude_binary
  tags: ["claude-code"]

- name: Install Claude Code via curl script
  ansible.builtin.shell:
    cmd: curl -fsSL {{ claude_code_install_script_url }} | bash
  args:
    creates: "{{ claude_code_binary_path }}"
  when: not claude_binary.stat.exists
  tags: ["claude-code"]

- name: Verify Claude Code installation (Ubuntu/Debian)
  ansible.builtin.command:
    cmd: "{{ claude_code_binary_path }} --version"
  register: claude_version
  changed_when: false
  failed_when: claude_version.rc != 0
  tags: ["claude-code"]
```

**Why**: Uses `stat` check + `creates:` for idempotency. curl script installation is the official method for Debian-based systems.

---

## Step 8: Initialize Molecule Testing

Initialize Molecule in the role directory:

```bash
cd roles/claude-code
molecule init scenario default --driver-name podman
```

**This creates**:
- `molecule/default/molecule.yml` - Test configuration
- `molecule/default/converge.yml` - Playbook to test
- `molecule/default/verify.yml` - Assertions

---

## Step 9: Configure Molecule Tests

### molecule.yml

**File**: `roles/claude-code/molecule/default/molecule.yml`

```yaml
---
dependency:
  name: galaxy

driver:
  name: podman

platforms:
  - name: ubuntu2404
    image: geerlingguy/docker-ubuntu2404-ansible
    pre_build_image: true
    command: ""
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: false

  - name: debian12
    image: geerlingguy/docker-debian12-ansible
    pre_build_image: true
    command: ""
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: false

provisioner:
  name: ansible
  inventory:
    host_vars:
      ubuntu2404:
        claude_code_enabled: true
      debian12:
        claude_code_enabled: true

verifier:
  name: ansible
```

### converge.yml

**File**: `roles/claude-code/molecule/default/converge.yml`

```yaml
---
- name: Converge
  hosts: all
  become: false
  tasks:
    - name: Include claude-code role
      ansible.builtin.include_role:
        name: claude-code
```

### verify.yml

**File**: `roles/claude-code/molecule/default/verify.yml`

```yaml
---
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: Check Claude Code binary exists
      ansible.builtin.stat:
        path: "{{ ansible_env.HOME }}/.local/bin/claude"
      register: result
      failed_when: not result.stat.exists

    - name: Check Claude Code is executable
      ansible.builtin.file:
        path: "{{ ansible_env.HOME }}/.local/bin/claude"
        state: file
        mode: '0755'
      check_mode: true
      register: result
      failed_when: result.changed

    - name: Verify Claude Code runs
      ansible.builtin.command:
        cmd: "{{ ansible_env.HOME }}/.local/bin/claude --version"
      register: version_output
      changed_when: false
      failed_when: version_output.rc != 0

    - name: Display Claude Code version
      ansible.builtin.debug:
        msg: "Claude Code version: {{ version_output.stdout }}"
```

**Why**: Tests verify binary existence, executability, and functionality across both Ubuntu and Debian platforms.

---

## Step 10: Run Molecule Tests

Execute the full test cycle:

```bash
cd roles/claude-code

# Run full test cycle (create, converge, verify, destroy)
molecule test

# Or run individual steps for faster iteration:
molecule create     # Create containers
molecule converge   # Run playbook
molecule verify     # Run assertions
molecule login      # SSH into container for debugging
molecule destroy    # Clean up containers
```

**Expected output**:
- First run: `changed=X` (installation happens)
- Second run: `changed=0` (idempotency verified)
- Verify phase: All assertions pass

---

## Step 11: Add Role to Main Playbook

**File**: `main.yml` (repository root)

Add the role to the playbook:

```yaml
---
- name: Configure workstation
  hosts: all
  become: false

  roles:
    # ... existing roles ...

    - role: claude-code
      when: claude_code_enabled | default(true) | bool
      tags: ["claude-code"]
```

**Why**: Integrates the role into the main playbook with tag support for selective execution.

---

## Step 12: Test Locally (Optional)

Test the role on your local system:

```bash
# macOS
ansible-playbook main.yml --tags claude-code --ask-become-pass

# Ubuntu/Debian
ansible-playbook main.yml --tags claude-code
```

**Verify installation**:
```bash
claude --version
```

---

## Step 13: Run ansible-lint

Ensure code quality:

```bash
cd roles/claude-code
ansible-lint .

# From repository root
ansible-lint
```

**Fix any issues** reported by the linter before committing.

---

## Step 14: Update Documentation

### README.md

Add to the "Available tags" section:

```markdown
# Available tags: ..., claude-code
ansible-playbook main.yml --tags claude-code
```

Add to the roles list:

```markdown
- **claude-code**: Installs Claude Code CLI (macOS via Homebrew, Ubuntu/Debian via curl)
```

### CLAUDE.md

Add to the "Roles with Molecule tests" section:

```markdown
- claude-code
```

---

## Step 15: Create Pull Request

Follow the repository's PR workflow:

```bash
# Ensure all changes are committed
git add roles/claude-code
git add specs/001-claude-code-role
git add main.yml README.md CLAUDE.md

# Commit with conventional format
git commit -m "feat(claude-code): add claude-code installation role

- Add support for macOS (Homebrew), Ubuntu, and Debian
- Implement OS-aware architecture pattern
- Add comprehensive Molecule tests for Ubuntu/Debian
- Add feature flag support (claude_code_enabled)
- Update main playbook and documentation

Closes #XXX"

# Push to branch
git push origin 001-claude-code-role

# Create PR using gh CLI
gh pr create \
  --title "feat(claude-code): add claude-code installation role" \
  --body "## Summary

Adds a new Ansible role to install Claude Code across macOS, Ubuntu, and Debian platforms.

## Implementation

- **macOS**: Homebrew cask installation
- **Ubuntu/Debian**: Official curl script installation
- **Testing**: Full Molecule test coverage for Ubuntu 24.04 and Debian 12
- **Idempotency**: Verified with \`changed=0\` on second run
- **Feature flag**: \`claude_code_enabled\` (default: true)

## Test Results

\`\`\`
✅ Molecule tests: PASSED (Ubuntu 24.04, Debian 12)
✅ Idempotency: VERIFIED (changed=0)
✅ ansible-lint: PASSED
\`\`\`

## Checklist

- [x] Constitution compliance verified
- [x] Molecule tests pass
- [x] ansible-lint passes
- [x] Documentation updated (README.md, CLAUDE.md)
- [x] Conventional commit format used
" \
  --base main \
  --head 001-claude-code-role
```

---

## Testing Checklist

Before submitting PR, verify:

- [ ] Molecule tests pass on Ubuntu 24.04
- [ ] Molecule tests pass on Debian 12
- [ ] Idempotency verified (`changed=0` on second run)
- [ ] ansible-lint shows no errors
- [ ] Role follows OS-aware architecture pattern
- [ ] Variables follow naming conventions
- [ ] Documentation updated (README.md, CLAUDE.md)
- [ ] Commits use conventional format
- [ ] CI checks pass (lint, test-roles, integration-test)

---

## Troubleshooting

### Molecule tests fail with "curl: command not found"

**Solution**: Ensure curl is installed in test containers. Add to converge.yml:

```yaml
- name: Install curl
  ansible.builtin.apt:
    name: curl
    state: present
  become: true
```

### Idempotency test fails (changed > 0 on second run)

**Solution**: Check that:
1. `creates:` parameter is set correctly on shell tasks
2. `stat` check is working properly
3. Homebrew module is used for macOS (inherently idempotent)

### CI pipeline fails

**Solution**: Review GitHub Actions logs:
```bash
gh run list
gh run view <run-id>
```

Common issues:
- ansible-lint errors: Fix syntax/style issues
- Molecule tests timeout: Increase timeout in molecule.yml
- Integration test fails: Test role in isolation first

---

## Next Steps

After PR is merged:

1. **Monitor auto-release**: semantic-release will create a new minor version
2. **Update CHANGELOG**: Automatically generated by semantic-release
3. **Test on real systems**: Manually verify on macOS, Ubuntu, and Debian
4. **Document in GitHub release**: Add release notes if needed

---

## Resources

- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Claude Code Documentation](https://code.claude.com/docs/en/setup)
- [Repository Constitution](.specify/memory/constitution.md)
- [Research Findings](./research.md)
- [Data Model](./data-model.md)

---

## Summary

This quickstart provides a step-by-step implementation guide following the repository's patterns:

1. ✅ **OS-aware architecture**: Separate tasks per OS family
2. ✅ **Test-first**: Molecule tests created before implementation
3. ✅ **Idempotent**: Verified with `changed=0` on re-run
4. ✅ **Constitution compliant**: All principles followed
5. ✅ **Simple**: No over-engineering, follows YAGNI

**Time estimate**: 2-4 hours for experienced Ansible developers

**Outcome**: A production-ready role that passes all CI checks and can be merged to main.
