# Ansible Role: uv

This role configures shell integration for the `uv` Python package installer.

UV (pronounced "you-vee") is an extremely fast Python package installer and resolver that serves as a drop-in replacement for pip and pip-tools. It's written in Rust and developed by the Astral team.

## Requirements

- Ansible 2.10 or higher
- macOS
- `uv` already installed on the system

## Role Variables

No variables are currently used in this role.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - uv
```

## Features

- Configures shell integration with `uv tool update-shell`

## Tags

- `uv`: All tasks related to uv configuration

## License

MIT 