# Quickstart Guide: Testing Debian Compatibility

**Date**: 2025-12-09
**Branch**: `feat/debian-compatibility`
**For**: Developers implementing and testing Debian support

## Prerequisites

Before testing Debian compatibility, ensure you have:

- ✅ Podman installed and configured
- ✅ Ansible 2.15+ installed
- ✅ Molecule 6.x installed
- ✅ Working directory: `/Users/saewyn/Documents/laptop_setup`
- ✅ Branch: `feat/debian-compatibility`

### Installing Dependencies (macOS)

```bash
# Install Podman
brew install podman

# Start Podman machine
podman machine init
podman machine start

# Install Ansible and Molecule
pip3 install --user ansible molecule molecule-plugins[podman]

# Verify installation
ansible --version
molecule --version
podman --version
```

### Installing Dependencies (Ubuntu/Debian)

```bash
# Install Podman
sudo apt update
sudo apt install -y podman

# Install Ansible and Molecule
pip3 install --user ansible molecule molecule-plugins[podman]

# Verify installation
ansible --version
molecule --version
podman --version
```

## Quick Test: Verify Existing Debian Support

Test the 6 roles that already have Debian support to ensure baseline functionality.

### Test a Single Role (Example: zsh)

```bash
cd roles/zsh
molecule test
```

**Expected Output**:
```
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
...
INFO     Running default > verify
...
PLAY RECAP *********************************************************************
debian12               : ok=X    changed=0    unreachable=0    failed=0
```

### Test All Debian-Compatible Roles

```bash
#!/bin/bash
# Test all roles with existing Debian support

DEBIAN_ROLES=("base-tools" "cursor" "mise" "rancher-desktop" "warp" "zsh")

for role in "${DEBIAN_ROLES[@]}"; do
    echo "========================================="
    echo "Testing role: $role"
    echo "========================================="

    cd "roles/$role"
    molecule test

    if [ $? -eq 0 ]; then
        echo "✅ $role: PASSED"
    else
        echo "❌ $role: FAILED"
    fi

    cd ../..
done
```

## Implementing Debian Support for a Role

Follow these steps to add Debian support to a role (example: `git`).

### Step 1: Create OS-Specific Task File

Create `roles/git/tasks/install-Debian.yml`:

```yaml
---
# Debian/Ubuntu-specific installation for git

- name: Install git via apt
  ansible.builtin.apt:
    name: git
    state: present
    update_cache: true
  become: true
  tags: git
```

### Step 2: Create OS-Specific Variables

Create `roles/git/vars/Debian.yml`:

```yaml
---
# Debian/Ubuntu-specific variables for git

git_package: git
git_credential_helper_default: "cache --timeout=3600"
```

### Step 3: Update Main Task File

Verify `roles/git/tasks/main.yml` includes OS-specific tasks:

```yaml
---
- name: Include OS-specific variables
  ansible.builtin.include_vars: "{{ ansible_os_family }}.yml"
  tags: git

- name: Include OS-specific installation tasks
  ansible.builtin.include_tasks: "install-{{ ansible_os_family }}.yml"
  when: ansible_os_family in ['Darwin', 'Debian']
  tags: git

- name: Configure Git settings
  # ... existing configuration tasks
```

### Step 4: Update Molecule Configuration

Edit `roles/git/molecule/default/molecule.yml` to add Debian 12 platform:

```yaml
---
dependency:
  name: galaxy
driver:
  name: podman
platforms:
  - name: ubuntu2404
    image: geerlingguy/docker-ubuntu2404-ansible:latest
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
  - name: debian12
    image: geerlingguy/docker-debian12-ansible:latest
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
provisioner:
  name: ansible
  config_options:
    defaults:
      callbacks_enabled: profile_tasks, timer, yaml
verifier:
  name: ansible
```

### Step 5: Update Converge Playbook

Edit `roles/git/molecule/default/converge.yml` to test role behavior:

```yaml
---
- name: Converge
  hosts: all
  become: true
  vars:
    git_enabled: true
    git_username: "Test User"
    git_email: "test@example.com"
    git_credential_helper: "cache --timeout=3600"
  roles:
    - role: git
```

### Step 6: Create Verification Tests

Edit `roles/git/molecule/default/verify.yml` to assert expected outcomes:

```yaml
---
- name: Verify
  hosts: all
  gather_facts: true
  tasks:
    - name: Check if git is installed
      ansible.builtin.command: git --version
      register: git_version
      changed_when: false
      failed_when: git_version.rc != 0

    - name: Verify git version output
      ansible.builtin.assert:
        that:
          - "'git version' in git_version.stdout"
        fail_msg: "Git is not properly installed"
        success_msg: "Git is installed and working"

    - name: Check git configuration - user.name
      ansible.builtin.command: git config --global user.name
      register: git_user_name
      changed_when: false
      failed_when: false

    - name: Verify git user.name is configured
      ansible.builtin.assert:
        that:
          - git_user_name.stdout == "Test User"
        fail_msg: "Git user.name not configured correctly"
        success_msg: "Git user.name configured correctly"

    - name: Check git configuration - user.email
      ansible.builtin.command: git config --global user.email
      register: git_user_email
      changed_when: false
      failed_when: false

    - name: Verify git user.email is configured
      ansible.builtin.assert:
        that:
          - git_user_email.stdout == "test@example.com"
        fail_msg: "Git user.email not configured correctly"
        success_msg: "Git user.email configured correctly"
```

### Step 7: Run Molecule Tests

```bash
cd roles/git

# Test cycle (create → converge → verify → destroy)
molecule test

# Or step-by-step for debugging:
molecule create      # Create containers
molecule converge    # Run the role
molecule verify      # Run verification tests
molecule login       # SSH into container (optional)
molecule destroy     # Clean up containers
```

## Testing Workflow

### 1. Development Cycle

```bash
# Create containers once
molecule create

# Iterative development loop:
molecule converge    # Apply changes
molecule verify      # Test changes
# ... make code changes ...
molecule converge    # Re-apply
molecule verify      # Re-test

# Verify idempotency (critical!)
molecule converge    # Should show "changed=0"

# Clean up
molecule destroy
```

### 2. Full Test Suite

```bash
# Run complete test cycle
molecule test

# Expected stages:
# 1. dependency  - Install Ansible Galaxy dependencies
# 2. cleanup     - Remove any existing containers
# 3. destroy     - Ensure clean slate
# 4. syntax      - Check playbook syntax
# 5. create      - Create test containers
# 6. prepare     - Prepare containers (if needed)
# 7. converge    - Run the role (first time)
# 8. idempotence - Run the role again (should be changed=0)
# 9. verify      - Run verification tests
# 10. cleanup    - Final cleanup
# 11. destroy    - Remove containers
```

### 3. Platform-Specific Testing

```bash
# Test only Debian 12
molecule test -- --platform-name debian12

# Test only Ubuntu 24.04
molecule test -- --platform-name ubuntu2404
```

## Troubleshooting

### Issue: Podman Machine Not Started (macOS)

**Symptom**:
```
Error: podman machine is not running
```

**Solution**:
```bash
podman machine start
```

---

### Issue: Container Image Not Found

**Symptom**:
```
Error: error creating container storage: the container name "debian12" is already in use
```

**Solution**:
```bash
molecule destroy
molecule test
```

---

### Issue: GPG Key Download Fails

**Symptom**:
```
fatal: [debian12]: FAILED! => {"msg": "Failed to download GPG key"}
```

**Solution**:
This may occur in containers with network restrictions. Add retry logic:

```yaml
- name: Download GPG key
  ansible.builtin.get_url:
    url: "https://example.com/key.gpg"
    dest: /tmp/key.gpg
  retries: 3
  delay: 5
```

---

### Issue: GUI Application Installation Fails

**Symptom**:
```
fatal: [debian12]: FAILED! => {"msg": "Package X requires display server"}
```

**Solution**:
Disable GUI applications in Molecule tests:

```yaml
# In molecule/default/converge.yml
vars:
  cursor_install_extensions: false  # Skip GUI-dependent features
  install_gui_apps: false
```

Or allow failures:

```yaml
- name: Install GUI application
  ansible.builtin.apt:
    name: cursor
    state: present
  failed_when: false  # Allow failure in containers
```

---

### Issue: Idempotence Check Fails

**Symptom**:
```
CRITICAL Idempotence test failed because of the following tasks:
* [debian12] => git => Download git binary
```

**Solution**:
Add proper idempotency checks:

```yaml
- name: Check if git is already installed
  ansible.builtin.stat:
    path: /usr/bin/git
  register: git_installed

- name: Install git
  ansible.builtin.apt:
    name: git
    state: present
  when: not git_installed.stat.exists
```

---

### Issue: Permission Denied in Container

**Symptom**:
```
fatal: [debian12]: FAILED! => {"msg": "Permission denied"}
```

**Solution**:
Use `become: true` for system-level operations:

```yaml
- name: Install package
  ansible.builtin.apt:
    name: package
    state: present
  become: true
```

---

### Issue: Architecture Detection Fails

**Symptom**:
```
fatal: [debian12]: FAILED! => {"msg": "Unsupported architecture: aarch64"}
```

**Solution**:
Use architecture mapping:

```yaml
- name: Set architecture variable
  ansible.builtin.set_fact:
    package_architecture: "{{ 'amd64' if ansible_architecture == 'x86_64' else 'arm64' }}"

- name: Download binary for correct architecture
  ansible.builtin.get_url:
    url: "https://example.com/binary-{{ package_architecture }}.tar.gz"
    dest: /tmp/binary.tar.gz
```

---

## Verification Checklist

After implementing Debian support for a role, verify:

- [ ] `tasks/install-Debian.yml` created with proper installation logic
- [ ] `vars/Debian.yml` created with OS-specific variables
- [ ] `tasks/main.yml` includes OS-specific tasks via `include_tasks`
- [ ] `molecule/default/molecule.yml` includes Debian 12 platform
- [ ] `molecule/default/converge.yml` sets test variables
- [ ] `molecule/default/verify.yml` asserts expected outcomes
- [ ] `molecule test` passes without errors
- [ ] Idempotency check passes (changed=0 on second run)
- [ ] Verification tests pass on both Ubuntu and Debian
- [ ] Role is tagged in `main.yml` for selective execution

## CI Pipeline Integration

Once local testing passes, the CI pipeline will automatically test Debian support:

### CI Workflow (`.github/workflows/ci.yml`)

The CI pipeline will:
1. Run `ansible-lint` on all playbooks
2. Execute Molecule tests for all roles (including Debian 12 containers)
3. Run full playbook integration test on Ubuntu and Debian

### Triggering CI

```bash
# Push to feature branch
git add .
git commit -m "feat(git): add debian support"
git push origin feat/debian-compatibility

# CI will automatically run Molecule tests on:
# - Ubuntu 24.04 containers
# - Debian 12 containers
```

### Checking CI Results

GitHub Actions will report:
- ✅ `lint` - Ansible linting passed
- ✅ `test-roles` - Molecule tests passed for all roles
- ✅ `integration-test` - Full playbook execution passed

## Next Steps

1. **Test existing Debian-compatible roles** (base-tools, cursor, mise, rancher-desktop, warp, zsh)
2. **Implement Debian support for P1 roles** (git, vim, gpg)
3. **Implement Debian support for P2 roles** (uv, copier, gita)
4. **Update documentation** (README.md, CLAUDE.md, constitution.md)
5. **Create pull request** with all Debian compatibility changes

## Reference: Molecule Commands

| Command | Description |
|---------|-------------|
| `molecule create` | Create test containers |
| `molecule converge` | Run the role in containers |
| `molecule verify` | Run verification tests |
| `molecule test` | Full test cycle (create → converge → verify → destroy) |
| `molecule login` | SSH into a container for debugging |
| `molecule destroy` | Remove test containers |
| `molecule list` | List active containers |
| `molecule check` | Dry-run mode (no changes) |
| `molecule syntax` | Validate playbook syntax |

## Additional Resources

- **Molecule Documentation**: https://molecule.readthedocs.io/
- **Ansible Best Practices**: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
- **Podman Documentation**: https://docs.podman.io/
- **Jeff Geerling's Ansible for DevOps**: https://www.ansiblefordevops.com/

---

**Document Version**: 1.0.0
**Last Updated**: 2025-12-09
