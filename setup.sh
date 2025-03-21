#!/bin/bash

set -e
set -o pipefail

# Install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
  echo "[INFO] Install macOS Command Line Tools"
  xcode-select --install
fi

# Install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
  echo "[INFO] Install Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
  echo "[INFO] Install Ansible"
  brew install ansible
fi

echo "[INFO] Done"
exit 0
