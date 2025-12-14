# Docker Role

Ansible role for installing Docker on macOS, Ubuntu, and Debian with support for two installation modes.

## Installation Modes

### Docker Mode (Default)
Installs official Docker software:
- **macOS**: Docker Desktop via Homebrew
- **Ubuntu/Debian**: Docker Engine CE from official repository

### Rancher Desktop Mode
Installs Rancher Desktop as an alternative to Docker Desktop:
- **macOS**: Rancher Desktop DMG from GitHub releases
- **Ubuntu/Debian**: Rancher Desktop .deb package from GitHub releases

## Requirements

### macOS
- Homebrew (installed by base-tools role)
- macOS 11.0 or later

### Ubuntu/Debian
- Ubuntu 24.04 LTS / Debian 12 or later
- Internet connection for repository access
- sudo privileges

## Role Variables

### Available in `defaults/main.yml`:

```yaml
# Installation mode: 'docker' (official) or 'rancher-desktop'
docker_mode: "docker"

# Rancher Desktop configuration (used when docker_mode == 'rancher-desktop')
rancher_desktop:
  repo: "rancher-sandbox/rancher-desktop"
  asset_pattern: "Rancher.Desktop-.+\\.aarch64\\.dmg$"
  version: "1"

# Docker Engine configuration (used when docker_mode == 'docker')
docker_engine:
  enable_service: true
  add_user_to_group: true
```

### Configuration in `group_vars/all.yml`:

```yaml
# Choose installation mode
docker_mode: "docker"  # or "rancher-desktop"
```

## Dependencies

- `base-tools` role (for package manager setup)

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: docker
      vars:
        docker_mode: "docker"
```

## Tags

- `docker`: All docker installation tasks

## Usage

Install with official Docker:
```bash
ansible-playbook main.yml --tags docker
```

Install with Rancher Desktop:
```bash
ansible-playbook main.yml --tags docker -e "docker_mode=rancher-desktop"
```

## Testing

This role includes Molecule tests for both modes:

```bash
cd roles/docker
molecule test
```

## Platform-Specific Notes

### macOS
- Docker Desktop requires macOS 11.0+
- Docker Desktop will appear in Applications folder
- Docker CLI available after first launch

### Ubuntu/Debian
- Adds Docker's official GPG key and repository
- Installs docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin
- Adds current user to docker group (requires re-login)
- Enables and starts docker.service and containerd.service

### Container/CI Environments
- Systemd service management gracefully fails in containers
- Role completion indicates success even if services can't start

## License

MIT

## Author

Theo Poccard
