# Contributing Guide

Thank you for considering contributing to this Ansible playbook repository! This guide will help you get started.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Submitting Changes](#submitting-changes)
- [Role Development](#role-development)
- [Commit Message Guidelines](#commit-message-guidelines)

## Getting Started

### Prerequisites

- Git
- Python 3.11+
- Ansible 2.15+
- Podman (for testing)
- Pre-commit

### Initial Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/laptop_setup.git
   cd laptop_setup
   ```

3. Set up development environment:

   ```bash
   make setup
   # Or manually:
   ./scripts/dev-setup.sh
   ```

4. Create a feature branch:

   ```bash
   git checkout -b feat/your-feature-name
   ```

## Development Workflow

### 1. Make Your Changes

Edit the relevant files following our [coding standards](#coding-standards).

### 2. Test Locally

```bash
# Run pre-commit checks
pre-commit run --all-files

# Validate syntax
make syntax-check

# Test affected roles
make test-role ROLE=your-role

# Run full test suite
make test
```

### 3. Commit Changes

Use conventional commit format:

```bash
git add .
git commit -m "feat(role-name): add new feature"
```

The pre-commit hooks will run automatically.

### 4. Push and Create PR

```bash
git push origin feat/your-feature-name
```

Then create a Pull Request on GitHub.

## Coding Standards

### Ansible Best Practices

1. **Idempotency**: All tasks must be idempotent

   ```yaml
   # Good - idempotent
   - name: Install package
     package:
       name: vim
       state: present

   # Bad - not idempotent
   - name: Download file
     shell: wget http://example.com/file.tar.gz
   ```

2. **Use Native Modules**: Prefer Ansible modules over shell/command

   ```yaml
   # Good
   - name: Create directory
     file:
       path: /path/to/dir
       state: directory

   # Bad
   - name: Create directory
     shell: mkdir -p /path/to/dir
   ```

3. **Descriptive Names**: Use clear, descriptive task names

   ```yaml
   # Good
   - name: Install development tools via Homebrew

   # Bad
   - name: Install packages
   ```

4. **Variables**: Prefix role-specific variables with role name

   ```yaml
   # In roles/cursor/defaults/main.yml
   cursor_version: "latest"
   cursor_install_extensions: true

   # Not
   version: "latest"
   install_extensions: true
   ```

5. **Tags**: Always add appropriate tags

   ```yaml
   - name: Install Cursor IDE
     include_tasks: install.yml
     tags:
       - cursor
       - ide
   ```

### OS-Aware Architecture

All roles must follow the OS-aware pattern:

```
roles/example/
├── tasks/
│   ├── main.yml              # Entry point with OS detection
│   ├── install-Darwin.yml    # macOS-specific installation
│   ├── install-Debian.yml    # Ubuntu-specific installation
│   └── configure.yml         # Common configuration
├── vars/
│   ├── Darwin.yml            # macOS variables
│   └── Debian.yml            # Ubuntu variables
├── defaults/
│   └── main.yml              # Default variables
└── molecule/                 # Testing infrastructure
    └── default/
        ├── molecule.yml
        ├── converge.yml
        └── verify.yml
```

**Example main.yml:**

```yaml
---
- name: Include OS-specific variables
  include_vars: "{{ ansible_os_family }}.yml"
  tags: example

- name: Include OS-specific installation tasks
  include_tasks: "install-{{ ansible_os_family }}.yml"
  tags: example

- name: Include common configuration
  include_tasks: configure.yml
  tags: example
```

### YAML Style

Follow `.yamllint` configuration:

```yaml
---
# Good formatting
- name: Task description
  module:
    parameter1: value1
    parameter2: value2
  when: condition
  tags:
    - tag1

# Bad formatting
- name: Task description
  module: { parameter1: value1, parameter2: value2 }
```

### Documentation

1. **Inline Comments**: Explain complex logic

   ```yaml
   # Install Rosetta 2 for Apple Silicon Macs to run Intel-based applications
   - name: Check if Rosetta 2 is needed
     stat:
       path: /usr/libexec/rosetta
     register: rosetta_check
   ```

2. **Variable Documentation**: Document in group_vars/all.yml

   ```yaml
   # Cursor IDE Configuration
   cursor_enabled: true          # Enable Cursor IDE installation
   cursor_version: "latest"      # Version to install (latest, 1.0.0, etc.)
   cursor_install_extensions: true  # Install IDE extensions
   ```

3. **Role README**: Keep role-specific README files updated

## Testing Requirements

### Molecule Tests Required

All roles MUST have Molecule tests. No exceptions.

#### Creating Tests

1. **Create Molecule scenario** (if not exists):

   ```bash
   cd roles/your-role
   molecule init scenario
   ```

2. **Write converge.yml**:

   ```yaml
   ---
   - name: Converge
     hosts: all
     tasks:
       - name: Include role
         include_role:
           name: your-role
   ```

3. **Write verify.yml**:

   ```yaml
   ---
   - name: Verify
     hosts: all
     tasks:
       - name: Check package is installed
         command: which your-package
         register: result
         failed_when: result.rc != 0
         changed_when: false
   ```

4. **Test the role**:

   ```bash
   molecule test
   ```

### Test Locally Before Pushing

```bash
# Run pre-commit
make pre-commit

# Test specific role
make test-role ROLE=your-role

# Run all tests
make test

# Validate playbook
make validate
```

### CI/CD Tests

All PRs must pass:

1. Ansible Lint
2. YAML Lint
3. Syntax Check
4. Molecule Tests (all roles)
5. Integration Tests
6. Security Scans

## Submitting Changes

### Pull Request Process

1. **Ensure tests pass locally**
2. **Update documentation** if needed
3. **Fill out PR template** completely
4. **Request review** from maintainers
5. **Address feedback** promptly
6. **Keep PR focused** - one feature per PR

### PR Checklist

- [ ] Pre-commit hooks pass
- [ ] All CI checks pass
- [ ] Molecule tests added/updated
- [ ] Documentation updated
- [ ] CLAUDE.md updated (if architecture changes)
- [ ] group_vars/all.yml updated (if new variables)
- [ ] Tested on macOS (if applicable)
- [ ] Tested on Ubuntu (if applicable)
- [ ] Idempotency verified
- [ ] No hardcoded secrets
- [ ] Follows OS-aware architecture

### Review Process

1. Automated checks run first
2. Maintainer review
3. Address feedback
4. Approval and merge

## Role Development

### Creating a New Role

1. **Create role structure**:

   ```bash
   ansible-galaxy init roles/your-role
   ```

2. **Follow OS-aware architecture**:
   - Create `tasks/install-Darwin.yml`
   - Create `tasks/install-Debian.yml`
   - Create `vars/Darwin.yml`
   - Create `vars/Debian.yml`

3. **Add to main playbook**:

   ```yaml
   # main.yml
   - name: Configure Your Role
     include_role:
       name: your-role
     tags:
       - your-role
   ```

4. **Add variables to group_vars/all.yml**:

   ```yaml
   # Your Role Configuration
   your_role_enabled: true
   your_role_setting: "value"
   ```

5. **Create Molecule tests**:

   ```bash
   cd roles/your-role
   mkdir -p molecule/default
   # Create molecule.yml, converge.yml, verify.yml
   ```

6. **Test thoroughly**:

   ```bash
   molecule test
   ```

7. **Document**:
   - Add to README.md
   - Update CLAUDE.md if needed
   - Add inline comments

### Role Dependencies

If your role depends on others, specify in `meta/main.yml`:

```yaml
---
dependencies:
  - role: base-tools
    when: ansible_os_family in ['Darwin', 'Debian']
```

## Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Scopes

Use role names as scopes:

- `cursor`
- `mise`
- `zsh`
- `base-tools`
- etc.

### Examples

```bash
# Good commit messages
git commit -m "feat(cursor): add MCP server configuration"
git commit -m "fix(zsh): resolve plugin loading on Ubuntu"
git commit -m "docs: update installation instructions"
git commit -m "test(mise): add Molecule tests for tool installation"
git commit -m "ci: add parallel testing for roles"

# Bad commit messages
git commit -m "update stuff"
git commit -m "fix bug"
git commit -m "WIP"
```

## Code Review Guidelines

### As a Reviewer

- [ ] Check code follows style guide
- [ ] Verify tests are present and passing
- [ ] Test locally if possible
- [ ] Check for security issues
- [ ] Verify documentation is updated
- [ ] Ensure idempotency
- [ ] Check OS compatibility

### As a Contributor

- Be open to feedback
- Respond to comments promptly
- Make requested changes
- Keep discussion professional
- Ask questions if unclear

## Getting Help

- Check [AUTOMATION.md](AUTOMATION.md) for workflow documentation
- Review [CLAUDE.md](CLAUDE.md) for architecture details
- Read existing roles for examples
- Ask questions in PR discussions
- Open an issue if stuck

## Community

- Be respectful and inclusive
- Help others when possible
- Share knowledge and best practices
- Report issues constructively
- Suggest improvements

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
