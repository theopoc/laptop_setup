#!/bin/zsh

set -e
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${GREEN}[INFO] Starting macOS setup...${NC}"

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
