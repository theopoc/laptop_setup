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
warp_user: "{{ ansible_facts.user_id }}"
warp_group: "{{ ansible_facts.user_id }}"
```

### OS-Specific Variables

The role includes OS-specific variables from the `vars` directory:

- `darwin.yml` - macOS specific configurations
- `RedHat.yml`, `Debian.yml` - Linux distribution configurations

Key OS-specific variables:

```yaml
# macOS
warp_workflows_dir: "{{ ansible_facts.env.HOME }}/.warp/workflows"
warp_parent_dir: "{{ ansible_facts.env.HOME }}/.warp"

# Debian/Ubuntu
warp_workflows_dir: "{{ ansible_facts.env.HOME }}/.local/share/warp-terminal/workflows"
warp_parent_dir: "{{ ansible_facts.env.HOME }}/.local/share/warp-terminal"

# RedHat/Fedora
warp_workflows_dir: "{{ ansible_facts.env.HOME }}/.local/share/warp-terminal/workflows"
warp_parent_dir: "{{ ansible_facts.env.HOME }}/.local/share/warp-terminal"
```

### Custom Workflow Configuration

You can define custom workflows to be deployed:

```yaml
# In your playbook vars or group_vars/host_vars
warp_workflows:
  - workflow_name: "Ansible Playbook"
    workflow_command: !unsafe "ansible-playbook {{playbook}} {{inventory}} {{verbosity}}"
    workflow_tags:
      - ansible
      - automation
    workflow_description: "Run Ansible playbooks with custom parameters"
    workflow_arguments:
      - name: playbook
        description: "Path to the playbook file"
        default_value: "playbook.yml"
      - name: inventory
        description: "Path to inventory or comma-separated host list"
        default_value: "-i hosts"
      - name: verbosity
        description: "Verbosity level (e.g., -v, -vv, -vvv)"
        default_value: ""
    workflow_author: "DevOps Team"
    workflow_shells:
      - bash
      - zsh
  - workflow_name: "Docker Compose Up"
    workflow_command: !unsafe "docker compose -f {{compose_file}} up {{detach}}"
    workflow_tags:
      - docker
      - container
    workflow_description: "Start Docker Compose services"
    workflow_arguments:
      - name: compose_file
        description: "Path to docker-compose.yml"
        default_value: "docker-compose.yml"
      - name: detach
        description: "Run in detached mode"
        default_value: "-d"
```

Each workflow uses the `workflow.yaml.j2` template to generate a proper Warp workflow file.

## Dependencies

None.

## Example Playbook

Basic usage:

```yaml
- hosts: localhost
  roles:
    - role: warp
```

With custom workflows:

```yaml
- hosts: localhost
  vars:
    warp_workflows:
      - workflow_name: "Kubernetes Status"
        workflow_command: !unsafe "kubectl get {{resource}} -n {{namespace}} {{output}}"
        workflow_tags:
          - kubernetes
          - k8s
        workflow_description: "Get status of Kubernetes resources"
        workflow_arguments:
          - name: resource
            description: "Resource type (pods, deployments, services, etc.)"
            default_value: "pods"
          - name: namespace
            description: "Kubernetes namespace"
            default_value: "default"
          - name: output
            description: "Output format"
            default_value: "-o wide"
      - workflow_name: "Git Operations"
        workflow_command: !unsafe "git {{operation}} {{options}}"
        workflow_tags:
          - git
          - version-control
        workflow_description: "Common Git operations"
        workflow_arguments:
          - name: operation
            description: "Git operation (pull, push, commit, etc.)"
            default_value: "status"
          - name: options
            description: "Additional options"
            default_value: ""
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
- Linux: `~/.local/share/warp-terminal/workflows/`
- Windows: `%APPDATA%\warp\Warp\data\workflows\` (Not currently supported by this role)

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

## Role Implementation

The role follows these steps:
1. Load OS-specific variables
2. Install Warp using the appropriate method for the OS
3. Create necessary directories for Warp configuration
4. Deploy defined workflows using Jinja2 templates

## License

MIT

## Author Information

This role was created as part of an Ansible management playbook for developer workstation configuration. 