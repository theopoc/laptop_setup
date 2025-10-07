# Ansible Role: mise

This role installs and configures [mise](https://mise.jdx.dev/) (formerly rtx) on macOS and Ubuntu/Debian systems.

## Requirements

- **macOS**: Homebrew must be installed
- **Ubuntu/Debian**: Docker must be installed for molecule testing

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
mise_tools: []
```

A dictionary of tools to install with mise. Example:

```yaml
mise_tools:
  node: "lts"
  python: "3.11"
  golang: "1.21"
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  vars:
    mise_tools:
      node: "lts"
      python: "3.11"
  roles:
    - mise
```

## Testing with Molecule

This role includes molecule tests for Ubuntu.

### Prerequisites

Install molecule and docker driver:

```bash
pip install molecule molecule-docker ansible-lint
```

### Run Tests

```bash
# Run full test suite
cd roles/mise
molecule test

# Create instance and converge
molecule converge

# Run verification tests
molecule verify

# Destroy test instance
molecule destroy
```

### Test Platforms

- Ubuntu 22.04 (docker container)

## Platform Support

- macOS (via Homebrew)
- Ubuntu/Debian (via apt repository)

## License

MIT

## Author Information

This role was created for laptop management automation.
