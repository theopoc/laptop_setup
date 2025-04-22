# Ansible Role: Warp Terminal

This role installs and configures [Warp](https://www.warp.dev/), a modern, Rust-based terminal with powerful features like workflows, AI integration, and a modern UI.

## Requirements

- For macOS: Homebrew (recommended)
- For Debian/Ubuntu: apt package manager
- For Red Hat/Fedora: dnf package manager

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Enable or disable the role
warp_enabled: true

# Installation method - can be homebrew, apt, rpm, or other based on OS
warp_install_method: "homebrew"

# Homebrew specific settings
warp_homebrew_cask_name: "warp"
warp_homebrew_cask_greedy: true
warp_homebrew_cask_state: present

# Debian/Ubuntu specific settings
warp_deb_url: "https://releases.warp.dev/stable/v0.2024.05.21.14.54.stable_00/warp-terminal_0.2024.05.21.14.54.stable.00_amd64.deb"
warp_apt_state: present

# Red Hat/Fedora specific settings
warp_rpm_url: "https://releases.warp.dev/stable/v0.2024.05.21.14.54.stable_00/warp-terminal-0.2024.05.21.14.54.stable.00.x86_64.rpm"
warp_rpm_state: present

# Workflows directory settings
warp_workflows_create_dirs: true

# User settings
warp_user: "{{ ansible_user_id }}"
warp_group: "{{ ansible_user_id }}"
```

You can also define custom workflows to be deployed:

```yaml
# In your playbook vars or group_vars/host_vars
warp_workflows:
  - src: path/to/your/custom_workflow.yaml.j2
    dest: my_custom_workflow.yaml  # Optional, defaults to the basename of src
  - src: path/to/another/workflow.yaml.j2
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: warp
```

Or with custom workflows:

```yaml
- hosts: localhost
  vars:
    warp_workflows:
      - src: templates/docker_workflow.yaml.j2
      - src: templates/kubernetes_workflow.yaml.j2
        dest: k8s_commands.yaml
  roles:
    - role: warp
```

To disable the role:

```yaml
- hosts: localhost
  vars:
    warp_enabled: false
  roles:
    - role: warp
```

## Workflows

This role sets up the Warp workflows directory and creates example workflows. The location of the workflows directory varies by OS:

- macOS: `~/.warp/workflows/`
- Windows: `%APPDATA%\warp\Warp\data\workflows\`
- Linux: `~/.local/share/warp-terminal/workflows/`

### Default Workflows

The role creates these workflows by default:

1. **Ansible Playbook** - Run Ansible playbooks with customizable parameters

You can add more custom workflows using the `warp_workflows` variable.

## YAML Workflows Format

Warp workflows are defined in YAML files with the following structure:

```yaml
name: Workflow Name
command: command {{argument1}} {{argument2}}
tags:
  - tag1
  - tag2
description: Description of the workflow
arguments:
  - name: argument1
    description: Description of argument1
    default_value: default
  - name: argument2
    description: Description of argument2
    default_value: ~
author: Your Name
shells:
  - zsh
  - bash
```

## License

MIT

## Author Information

This role was created as part of an Ansible management playbook. 