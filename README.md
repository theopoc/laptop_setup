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

4. Grant Terminal Full Disk Access
   - Open System Preferences > Security & Privacy > Privacy
   - Select "Full Disk Access" from the left sidebar
   - Click the lock icon to make changes (enter your password)
   - Click the "+" button and add Terminal.app from /Applications/Utilities/
   - Ensure the checkbox next to Terminal.app is checked

5. Ensure you're logged in Apple ID

6. Change the username in the Ansible configuration (if needed):
   - Open the `hosts` file in your favorite text editor
   - Modify the `ansible_user` value to match your desired username:
     ```
     [mymac]
     127.0.0.1 ansible_user=your_new_username
     ```
   - Save the file
   - Note: Make sure the username you specify exists on your system and has the necessary permissions to execute the playbook tasks.

7. Run the playbook
```
ansible-playbook main.yml -i hosts --ask-become-pass
```
