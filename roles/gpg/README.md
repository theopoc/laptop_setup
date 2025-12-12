# GPG Role

This role configures GPG agent settings to control how long GPG keys are cached in memory.

## Requirements

- GPG must be installed on the system.

## Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `gpg_enabled` | Enable or disable the GPG configuration | `true` |
| `gpg_config_dir` | Directory for GPG configuration | `{{ ansible_facts.env.HOME }}/.gnupg` |
| `gpg_cache_ttl` | Default cache TTL in seconds | `28800` (8 hours) |
| `gpg_max_cache_ttl` | Maximum cache TTL in seconds | `28800` (8 hours) |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: gpg
      tags: ['gpg']
```

Now, let's add the role to your main.yml playbook:

```yml:main.yml
---
- name: Ping Test Playbook
  hosts: mymac
  connection: local
  gather_facts: true
  roles:
    - role: homebrew
      tags: ['homebrew']
    - role: appstore
      tags: ['appstore']
    - role: rosetta
      when: ansible_machine == 'arm64'
      tags: ['rosetta']
    - role: vim
      tags: ['vim']
    - role: iterm2
      tags: ['iterm2']
      when: iterm2_enabled | bool
    - role: cursor
      tags: ['cursor']
    - role: mise
      tags: ['mise']
    - role: gita
      tags: ['gita']
    - role: copier
      tags: ['copier']
    - role: uv
      tags: ['uv']
    - role: zsh
      tags: ['zsh']
    - role: macos_settings
      tags: ['macos_settings']
    - role: git
      tags: ['git']
    - role: rancher-desktop
      tags: ['rancher-desktop']
    - role: gpg
      tags: ['gpg']
```

To implement this, you'll need to:

1. Create the directory structure for the GPG role
2. Create the files listed above with the content provided
3. Add the role to your main playbook as shown

This role will:
- Create the ~/.gnupg directory if needed
- Set up the gpg-agent.conf with a cache time of 8 hours
- Reload the GPG agent when configuration changes
- Only modify the system when gpg_enabled is true

You can run this with: `ansible-playbook main.yml --tags gpg` 