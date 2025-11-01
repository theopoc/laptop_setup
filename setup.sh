#!/bin/zsh

set -e
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${GREEN}[INFO] Starting macOS setup...${NC}"

# Check for Full Disk Access (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  echo "${YELLOW}[SETUP] Checking Terminal Full Disk Access...${NC}"

  # Test if Terminal has Full Disk Access by trying to read a protected file
  if ! plutil -lint ~/Library/Preferences/com.apple.Terminal.plist &>/dev/null; then
    echo "${RED}[REQUIRED] Terminal needs Full Disk Access to run this playbook${NC}"
    echo ""
    echo "Please follow these steps:"
    echo "  1. System Preferences will open to Privacy & Security"
    echo "  2. Click the lock icon and enter your password"
    echo "  3. Scroll to 'Full Disk Access' in the left sidebar"
    echo "  4. Click the '+' button"
    echo "  5. Navigate to Applications/Utilities/Terminal.app"
    echo "  6. Select Terminal.app and click 'Open'"
    echo "  7. Ensure the checkbox next to Terminal.app is checked"
    echo ""
    echo "Opening System Preferences now..."

    # Open System Preferences to the right panel
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

    echo ""
    read -p "Press ENTER after granting Full Disk Access to continue..."

    # Verify again
    if ! plutil -lint ~/Library/Preferences/com.apple.Terminal.plist &>/dev/null; then
      echo "${RED}[ERROR] Full Disk Access not detected. Please grant the permission and run this script again.${NC}"
      exit 1
    fi
  fi

  echo "${GREEN}[OK] Terminal has Full Disk Access${NC}"
fi

# Install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
  echo "[INFO] Install Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Generate SSH key for GitHub
echo "${YELLOW}[SETUP] Configuring SSH key for GitHub...${NC}"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

if [[ ! -f "$SSH_KEY_PATH" ]]; then
  echo "${YELLOW}[INFO] Generating new SSH key...${NC}"
  read -p "Enter your GitHub email address: " github_email
  ssh-keygen -t ed25519 -C "$github_email" -f "$SSH_KEY_PATH" -N ""
  echo "${GREEN}[OK] SSH key generated${NC}"
else
  echo "${GREEN}[OK] SSH key already exists${NC}"
fi

# Configure SSH for GitHub
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/config" ]] || ! grep -q "Host github.com" "$HOME/.ssh/config"; then
  echo "${YELLOW}[INFO] Configuring SSH for GitHub...${NC}"
  cat >> "$HOME/.ssh/config" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
  chmod 600 "$HOME/.ssh/config"
  echo "${GREEN}[OK] SSH config updated${NC}"
fi

# Start ssh-agent and add key
eval "$(ssh-agent -s)" > /dev/null
ssh-add --apple-use-keychain "$SSH_KEY_PATH" 2>/dev/null

# Display public key
echo ""
echo "${GREEN}[IMPORTANT] Copy this SSH public key and add it to your GitHub account:${NC}"
echo ""
cat "${SSH_KEY_PATH}.pub"
echo ""
echo "${YELLOW}Steps to add the key to GitHub:${NC}"
echo "  1. Go to https://github.com/settings/ssh/new"
echo "  2. Give it a title (e.g., 'MacBook Pro')"
echo "  3. Paste the key above into the 'Key' field"
echo "  4. Click 'Add SSH key'"
echo ""
read -p "Press ENTER after adding the SSH key to GitHub..."

# Clone repository if not already in it
REPO_URL="git@github.com:USERNAME/ansible-mgmt-laptop.git"
REPO_DIR="$HOME/Documents/ansible-mgmt-laptop"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "${YELLOW}[INFO] Cloning repository...${NC}"
  read -p "Enter the SSH URL of your repository (default: $REPO_URL): " custom_repo_url
  REPO_URL="${custom_repo_url:-$REPO_URL}"

  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"

  if [[ $? -eq 0 ]]; then
    echo "${GREEN}[OK] Repository cloned successfully${NC}"
    cd "$REPO_DIR"
  else
    echo "${RED}[ERROR] Failed to clone repository. Please check your SSH key and repository URL.${NC}"
    exit 1
  fi
else
  echo "${GREEN}[OK] Already in repository directory${NC}"
fi

# Install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
  echo "[INFO] Install Ansible"
  brew install ansible
fi

# Install Ansible Collections (only if in repository)
if [[ -f requirements.yml ]]; then
  echo "[INFO] Install Ansible Collections"
  ansible-galaxy install -r requirements.yml
else
  echo "${YELLOW}[SKIP] requirements.yml not found, skipping collection installation${NC}"
fi

echo ""
echo "${GREEN}[SUCCESS] Setup completed!${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit group_vars/all.yml with your personal settings"
echo "  2. Edit hosts file with your username"
echo "  3. Run: ansible-playbook main.yml -i hosts --ask-become-pass"
echo ""
exit 0
