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

# Install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
  echo "[INFO] Install Ansible"
  brew install ansible
fi

# Install Ansible Collections
if [[ ! -x /usr/local/bin/ansible-galaxy ]]; then
  echo "[INFO] Install Ansible Collections"
  ansible-galaxy install -r requirements.yml
fi

echo "[INFO] Done"
exit 0
