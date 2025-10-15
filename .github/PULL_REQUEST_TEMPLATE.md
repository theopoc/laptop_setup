## Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] New role
- [ ] Role enhancement/update
- [ ] Bug fix
- [ ] Documentation update
- [ ] CI/CD improvement
- [ ] Refactoring
- [ ] Performance improvement

## Roles Changed

<!-- List the roles that were modified -->

-

## Motivation and Context

<!-- Why is this change required? What problem does it solve? -->
<!-- If it fixes an open issue, please link to the issue here -->

Closes #

## Testing

### Local Testing

<!-- Describe the tests you ran to verify your changes -->

- [ ] Ran playbook in check mode: `ansible-playbook main.yml -i hosts --check`
- [ ] Ran playbook successfully on test system
- [ ] Tested on macOS
- [ ] Tested on Ubuntu
- [ ] Ran ansible-lint without errors
- [ ] Ran yamllint without errors

### Molecule Testing

<!-- For roles with Molecule tests -->

- [ ] Molecule tests pass: `cd roles/<role_name> && molecule test`
- [ ] Molecule tests updated to cover new functionality
- [ ] Added new Molecule tests for new roles

### Test Output

```bash
# Paste relevant test output here
```

## OS Compatibility

<!-- Check all that apply -->

- [ ] macOS (Darwin)
- [ ] Ubuntu (Debian)
- [ ] OS-specific variables added to `vars/Darwin.yml` and `vars/Debian.yml`
- [ ] OS-specific tasks in separate files (`install-Darwin.yml`, `install-Debian.yml`)
- [ ] Follows OS-aware architecture pattern

## Configuration Changes

<!-- If applicable -->

- [ ] New variables added to `group_vars/all.yml`
- [ ] Variables documented with comments
- [ ] Default values provided
- [ ] Sensitive variables identified

## Documentation

- [ ] Updated `README.md` (if needed)
- [ ] Updated `CLAUDE.md` (if architecture changed)
- [ ] Added inline comments for complex logic
- [ ] Updated role `README.md` (if role-specific)

## Breaking Changes

<!-- List any breaking changes and migration steps -->

- [ ] This PR introduces breaking changes
- [ ] Migration guide provided

**Breaking changes:**

-

## Additional Notes

<!-- Any additional information that reviewers should know -->

## Pre-merge Checklist

- [ ] Pre-commit hooks pass
- [ ] All CI checks pass
- [ ] Code follows Ansible best practices
- [ ] Idempotency verified (running twice produces no changes)
- [ ] No hardcoded credentials or secrets
- [ ] Proper error handling implemented
- [ ] Used native Ansible modules (avoided shell/command when possible)

## Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

---

**Reviewers:** Please ensure all checkboxes are marked before approving.
