---
name: Bug Report
about: Report a bug or unexpected behavior
title: '[BUG] '
labels: bug
assignees: ''
---

## Description

<!-- A clear and concise description of the bug -->

## Environment

**Operating System:**

- [ ] macOS (version: )
- [ ] Ubuntu (version: )

**Ansible Version:**

```
# Output of: ansible --version
```

**Python Version:**

```
# Output of: python3 --version
```

## Affected Role(s)

<!-- Check all that apply -->
- [ ] base-tools
- [ ] cursor
- [ ] git
- [ ] mise
- [ ] rancher-desktop
- [ ] uv
- [ ] zsh
- [ ] warp
- [ ] vim
- [ ] gpg
- [ ] appstore
- [ ] macos_settings
- [ ] Other (specify):

## Steps to Reproduce

1.
2.
3.

## Expected Behavior

<!-- What you expected to happen -->

## Actual Behavior

<!-- What actually happened -->

## Error Output

```bash
# Paste relevant error output here
```

## Playbook Command Used

```bash
# The command you ran
ansible-playbook main.yml -i hosts --tags <tag>
```

## Configuration

**Relevant `group_vars/all.yml` settings:**

```yaml
# Paste relevant configuration
```

## Additional Context

<!-- Add any other context about the problem here -->

## Possible Solution

<!-- If you have ideas on how to fix this, please share -->

## Checklist

- [ ] I have checked the documentation
- [ ] I have searched for similar issues
- [ ] I have tested with the latest version
- [ ] I have run `ansible-lint` and fixed any issues
- [ ] I can reproduce this bug consistently
