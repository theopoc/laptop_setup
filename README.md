# Ansible Playbook for macOS

This repository contains an Ansible playbook for macOS. It installs Homebrew and other packages.

## Prerequisites

- Ansible
- macOS

# Install Xcode Command Line Tools
```
xcode-select --install
```


# install ansible with pip
```
sudo pip3 install --upgrade pip
pip3 install ansible
```

# Run the playbook
```
ansible-galaxy role install -r requirements.yml
ansible-playbook main.yml --ask-become-pass
```
