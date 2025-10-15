# Makefile for Ansible Playbook Management
# Provides convenient shortcuts for common tasks

.PHONY: help install test lint check clean setup molecule-test molecule-converge

# Default target
.DEFAULT_GOAL := help

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

## help: Show this help message
help:
	@echo "$(BLUE)Ansible Playbook Makefile Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Setup Commands:$(NC)"
	@echo "  make setup              - Initial development environment setup"
	@echo "  make install            - Install Ansible and dependencies"
	@echo ""
	@echo "$(GREEN)Testing Commands:$(NC)"
	@echo "  make test               - Run all tests (lint + molecule)"
	@echo "  make test-role ROLE=x   - Run Molecule tests for specific role"
	@echo "  make molecule-test      - Run Molecule tests for all roles"
	@echo "  make molecule-converge ROLE=x - Run Molecule converge for specific role"
	@echo ""
	@echo "$(GREEN)Linting Commands:$(NC)"
	@echo "  make lint               - Run all linters (ansible-lint + yamllint)"
	@echo "  make ansible-lint       - Run ansible-lint only"
	@echo "  make yamllint           - Run yamllint only"
	@echo ""
	@echo "$(GREEN)Playbook Commands:$(NC)"
	@echo "  make check              - Run playbook in check mode"
	@echo "  make syntax-check       - Check playbook syntax"
	@echo "  make run                - Run full playbook (prompts for become password)"
	@echo "  make run-tag TAG=x      - Run specific role by tag"
	@echo ""
	@echo "$(GREEN)Git & Pre-commit:$(NC)"
	@echo "  make pre-commit         - Run pre-commit on all files"
	@echo "  make pre-commit-install - Install pre-commit hooks"
	@echo ""
	@echo "$(GREEN)Utility Commands:$(NC)"
	@echo "  make clean              - Clean up temporary files"
	@echo "  make galaxy-install     - Install Ansible Galaxy dependencies"
	@echo "  make docs               - Generate documentation"

## setup: Initial development environment setup
setup:
	@echo "$(BLUE)Setting up development environment...$(NC)"
	@bash scripts/dev-setup.sh

## install: Install Ansible and dependencies
install:
	@echo "$(BLUE)Installing dependencies...$(NC)"
	pip3 install --user ansible ansible-lint yamllint molecule molecule-plugins[podman] jmespath
	@echo "$(GREEN)Dependencies installed!$(NC)"

## galaxy-install: Install Ansible Galaxy dependencies
galaxy-install:
	@echo "$(BLUE)Installing Ansible Galaxy dependencies...$(NC)"
	ansible-galaxy install -r requirements.yml
	@echo "$(GREEN)Galaxy dependencies installed!$(NC)"

## pre-commit-install: Install pre-commit hooks
pre-commit-install:
	@echo "$(BLUE)Installing pre-commit hooks...$(NC)"
	pip3 install --user pre-commit
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "$(GREEN)Pre-commit hooks installed!$(NC)"

## pre-commit: Run pre-commit on all files
pre-commit:
	@echo "$(BLUE)Running pre-commit hooks...$(NC)"
	pre-commit run --all-files

## syntax-check: Check playbook syntax
syntax-check:
	@echo "$(BLUE)Checking playbook syntax...$(NC)"
	ansible-playbook main.yml --syntax-check -i hosts
	@echo "$(GREEN)Syntax check passed!$(NC)"

## check: Run playbook in check mode
check: syntax-check
	@echo "$(BLUE)Running playbook in check mode...$(NC)"
	ansible-playbook main.yml -i hosts --check --diff

## run: Run full playbook
run: syntax-check
	@echo "$(BLUE)Running playbook...$(NC)"
	@echo "$(YELLOW)You will be prompted for become password$(NC)"
	ansible-playbook main.yml -i hosts --ask-become-pass

## run-tag: Run specific role by tag
run-tag:
ifndef TAG
	@echo "$(YELLOW)Usage: make run-tag TAG=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Running role: $(TAG)$(NC)"
	ansible-playbook main.yml -i hosts --tags $(TAG) --ask-become-pass

## ansible-lint: Run ansible-lint
ansible-lint:
	@echo "$(BLUE)Running ansible-lint...$(NC)"
	ansible-lint -v

## yamllint: Run yamllint
yamllint:
	@echo "$(BLUE)Running yamllint...$(NC)"
	yamllint -c .yamllint .

## lint: Run all linters
lint: ansible-lint yamllint
	@echo "$(GREEN)All linting passed!$(NC)"

## test: Run all tests
test: lint molecule-test
	@echo "$(GREEN)All tests passed!$(NC)"

## molecule-test: Run Molecule tests for all roles
molecule-test:
	@echo "$(BLUE)Running Molecule tests for all roles...$(NC)"
	@for role in roles/*/molecule; do \
		if [ -d "$$role" ]; then \
			role_name=$$(echo $$role | cut -d'/' -f2); \
			echo "$(BLUE)Testing role: $$role_name$(NC)"; \
			cd roles/$$role_name && molecule test && cd ../..; \
		fi \
	done
	@echo "$(GREEN)All Molecule tests passed!$(NC)"

## test-role: Run Molecule tests for specific role
test-role:
ifndef ROLE
	@echo "$(YELLOW)Usage: make test-role ROLE=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Testing role: $(ROLE)$(NC)"
	@if [ ! -d "roles/$(ROLE)/molecule" ]; then \
		echo "$(YELLOW)Warning: Role $(ROLE) does not have Molecule tests$(NC)"; \
		exit 1; \
	fi
	cd roles/$(ROLE) && molecule test

## molecule-converge: Run Molecule converge for specific role
molecule-converge:
ifndef ROLE
	@echo "$(YELLOW)Usage: make molecule-converge ROLE=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Running Molecule converge for: $(ROLE)$(NC)"
	cd roles/$(ROLE) && molecule converge

## molecule-verify: Run Molecule verify for specific role
molecule-verify:
ifndef ROLE
	@echo "$(YELLOW)Usage: make molecule-verify ROLE=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Running Molecule verify for: $(ROLE)$(NC)"
	cd roles/$(ROLE) && molecule verify

## molecule-login: Login to Molecule test container
molecule-login:
ifndef ROLE
	@echo "$(YELLOW)Usage: make molecule-login ROLE=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Logging into Molecule container for: $(ROLE)$(NC)"
	cd roles/$(ROLE) && molecule login

## molecule-destroy: Destroy Molecule test container
molecule-destroy:
ifndef ROLE
	@echo "$(YELLOW)Usage: make molecule-destroy ROLE=role_name$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Destroying Molecule container for: $(ROLE)$(NC)"
	cd roles/$(ROLE) && molecule destroy

## docs: Generate documentation
docs:
	@echo "$(BLUE)Generating documentation...$(NC)"
	@echo "Documentation generation not yet implemented"

## clean: Clean up temporary files
clean:
	@echo "$(BLUE)Cleaning up...$(NC)"
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type d -name '.pytest_cache' -delete
	find . -type d -name '*.egg-info' -delete
	find . -type f -name '.DS_Store' -delete
	@echo "$(GREEN)Cleanup complete!$(NC)"

## list-roles: List all available roles
list-roles:
	@echo "$(BLUE)Available roles:$(NC)"
	@ls -1 roles/ | grep -v ".DS_Store"

## list-tags: List all available tags
list-tags:
	@echo "$(BLUE)Available tags:$(NC)"
	@grep -h "tags:" main.yml | grep -v "#" | sed 's/.*tags://' | tr -d '[]' | tr ',' '\n' | sed 's/^[ \t]*//' | sort -u

## validate: Validate all configuration files
validate: syntax-check lint
	@echo "$(GREEN)All validations passed!$(NC)"

## update-galaxy: Update Ansible Galaxy roles
update-galaxy:
	@echo "$(BLUE)Updating Ansible Galaxy roles...$(NC)"
	ansible-galaxy install -r requirements.yml --force

## version: Show versions of installed tools
version:
	@echo "$(BLUE)Installed versions:$(NC)"
	@echo "Ansible: $$(ansible --version | head -n1)"
	@echo "Python: $$(python3 --version)"
	@echo "Ansible Lint: $$(ansible-lint --version)"
	@echo "Yamllint: $$(yamllint --version)"
	@if command -v molecule >/dev/null 2>&1; then echo "Molecule: $$(molecule --version | head -n1)"; fi
	@if command -v podman >/dev/null 2>&1; then echo "Podman: $$(podman --version)"; fi
