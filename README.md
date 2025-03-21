# Ansible Playbook for macOS

This repository contains an Ansible playbook for macOS. It installs Homebrew and other packages.

## Installation

1. Generate an SSH key
```
ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_rsa -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

2. Add the SSH key to your Git provider

3. Clone the repository and run the setup script
```
git clone https://github.com/TheoPoc/ansible-mgmt-laptop.git
cd ansible-mgmt-laptop
./setup.sh
```

4. Ensure you're logged in Apple ID

5. Run the playbook
```
ansible-playbook main.yml -i hosts --ask-become-pass
```
