# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an Ansible playbook repository for automating workstation setup on macOS, Ubuntu, and Debian. It provides a modular, idempotent approach to provisioning development environments with OS-specific adaptations.

## Common Commands

### Running the Playbook

**Full playbook execution:**

```bash
ansible-playbook main.yml
```

**Run specific role using tags:**

```bash
# Available tags: base-tools, cursor, mise, zsh, git, warp, vim, gpg, docker, appstore, macos_settings, uv
ansible-playbook main.yml --tags <tag_name>
```

**Examples:**

```bash
# Install only Cursor IDE
ansible-playbook main.yml --tags cursor

# Configure Git only
ansible-playbook main.yml --tags git

# Install Cursor IDE and Git
ansible-playbook main.yml --tags cursor,git
```

### Testing with Molecule

**Test a specific role:**

```bash
cd roles/<role_name>
molecule test
```

**Test without destroying the container (for debugging):**

```bash
molecule converge  # Run playbook
molecule verify    # Run tests
molecule login     # SSH into container
molecule destroy   # Clean up when done
```

**Roles with Molecule tests:**

- appstore
- base-tools
- claude-code
- copier
- cursor
- git
- gita
- gpg
- iterm2
- mise
- docker
- uv
- vim
- warp
- zsh

**Roles without Molecule tests (macOS-only):**

- rosetta - Rosetta 2 installation for Apple Silicon Macs (requires macOS)
- macos_settings - macOS system settings configuration (requires macOS)

**Important:** Molecule uses Docker as the driver. Tests run in Ubuntu 24.04 (geerlingguy/docker-ubuntu2404-ansible) and Debian 12 (geerlingguy/docker-debian12-ansible) containers. macOS-only roles cannot be tested in containers and are automatically excluded from CI pipeline testing.

### Linting

```bash
ansible-lint
```

## Architecture

### Role Execution Pattern

All roles follow a consistent OS-aware architecture:

1. **OS Detection:** Roles use `ansible_os_family` fact to detect Darwin (macOS) or Debian (Ubuntu/Debian)
2. **Variable Loading:** Include OS-specific variables from `vars/{{ ansible_os_family }}.yml`
3. **Task Execution:** Include OS-specific tasks from `tasks/install-{{ ansible_os_family }}.yml`
4. **Configuration:** Apply common configuration tasks
5. **Optimization:** Avoid redundant tasks, use loop if possible
6. **Best practices:** Use shell, command and script as last resort and prefer native module instead
7. **Installation:** check the official documentation on the internet to see how to install tools properly

**Note:** `ansible_os_family` returns "Debian" for both Ubuntu and Debian distributions, so install-Debian.yml and Debian.yml files are shared between them.

**Example structure (cursor role):**

```
roles/cursor/
├── tasks/
│   ├── main.yml              # Entry point, includes OS-specific tasks
│   ├── install-Darwin.yml    # macOS-specific installation
│   ├── install-Debian.yml    # Ubuntu/Debian-specific installation
│   ├── setup-settings.yml    # Common configuration
│   └── install-extensions.yml
├── vars/
│   ├── Darwin.yml            # macOS variables
│   └── Debian.yml            # Ubuntu/Debian variables
└── molecule/                 # Testing infrastructure
```

### Configuration Management

**Single source of truth:** All user-configurable variables are defined in `group_vars/all.yml`

**Key configuration sections:**

- `homebrew`: Package manager configuration for macOS (taps, formulae, casks)
- `cursor_*`: IDE extensions, settings, keybindings, MCP configuration
- `mise_tools`: DevOps tools managed by mise (terraform, kubectl, helm, etc.)
- `git_*`: Git user configuration
- `docker_mode`: Docker installation mode ('docker' for official Docker Desktop/Engine, 'rancher-desktop' for Rancher Desktop)
- `warp_workflows`: Custom terminal workflows for Warp
- `appstore_apps`: Mac App Store applications (macOS only)
- `display_applications`: Dock configuration (macOS only)

### Idempotency and Conditionals

Roles use `when` conditionals for:

- OS-specific execution: `when: ansible_os_family == 'Darwin'`
- Architecture-specific: `when: ansible_machine == 'arm64'`
- Feature flags: `when: cursor_mcp_enabled | bool`

### Molecule Testing Strategy

Tests validate:

1. **Convergence:** Playbook runs without errors
2. **Idempotence:** Re-running produces no changes
3. **Verification:** Installed packages/configurations are correct

Test configurations disable features incompatible with containers (e.g., `cursor_install_extensions: false`).

## Development Guidelines (from .cursorrules)

### Ansible Best Practices

- Maintain idempotent design for all tasks
- Use roles from Ansible Galaxy where applicable
- Organize with `group_vars` and roles for modularity
- Implement tags for flexible task execution
- Use `block:` and `rescue:` for error handling
- Leverage Jinja2 templates for dynamic configurations
- Use handlers for service restarts only when necessary
- Validate playbooks with `ansible-lint` before running

### Testing Workflow - CRITICAL

**IMPORTANT:** When making changes to any role, you MUST follow this workflow:

1. **Make your changes** to role tasks, variables, or templates
2. **Update Molecule tests** to reflect your changes:
   - Update `molecule/default/converge.yml` if you modified role behavior
   - Update `molecule/default/verify.yml` to test new functionality
   - Add or modify host_vars in `molecule.yml` for new variables
3. **Run Molecule tests** to ensure everything works:

   ```bash
   cd roles/<role_name>
   molecule test
   ```

4. **Fix any failures** until tests pass successfully
5. **Verify idempotence** - the test should show "changed=0" on the second run

**Never skip testing!** All roles with `molecule/` directories must have passing tests before considering your work complete. This ensures that changes work in Ubuntu environments (the Molecule test target).

**Common test failures to watch for:**

- Missing packages or dependencies in containers
- Incorrect architecture detection (amd64 vs arm64)
- Features that require GUI/systemd (disable these in test configs)
- Network timeouts when downloading binaries (GitHub API rate limits)

### Role Dependencies

Some roles have dependencies managed through `meta/main.yml`:

- Roles depend on `base-tools` for package manager setup
- Use `ansible.builtin.include_vars` for OS-specific variables
- Use `ansible.builtin.include_tasks` for OS-specific task files

### Variable Naming Conventions

- Role-specific variables prefixed with role name (e.g., `cursor_extensions`, `git_username`)
- Boolean flags use `_enabled` suffix (e.g., `cursor_mcp_enabled`, `git_enabled`)
- Use `ansible_facts.user_id` directly in roles for user-specific paths (no intermediate variables)

### GitHub CI/CD Workflow Investigation

**IMPORTANT: Use GitHub MCP for investigating pipeline failures**

When investigating CI/CD pipeline issues, use the GitHub MCP tools to gather information:

**For workflow runs:**
```
- Use mcp__github__list_workflow_runs to see recent workflow executions
- Use mcp__github__get_workflow_run to get details about a specific run
- Use mcp__github__list_workflow_jobs to see jobs in a workflow run
- Use mcp__github__get_job_logs with failed_only=true to get only failed job logs
```

**Common investigation workflow:**

1. **List recent workflow runs** to identify the failing run
2. **Get workflow run details** to understand the failure
3. **Get failed job logs** to see specific error messages
4. **Analyze the logs** to identify root cause
5. **Fix the issue** in the workflow or code
6. **Create a PR** with the fix using `mcp__github__create_pull_request`

**Example:**
```
1. mcp__github__list_workflow_runs(owner="TheoPoc", repo="laptop_setup", workflow_id="ci.yml")
2. mcp__github__get_job_logs(owner="TheoPoc", repo="laptop_setup", run_id=123456, failed_only=true)
3. Analyze logs, fix issue
4. mcp__github__create_pull_request(owner="TheoPoc", repo="laptop_setup", title="fix(ci): ...", head="fix/branch", base="main")
```

### Git Workflow

**IMPORTANT: All features must go through Pull Requests**

This repository follows a strict PR-based workflow for all code changes:

**Branch Workflow:**

1. **Create a feature branch** from `main`:
   ```bash
   git checkout -b <type>/<description>
   ```

2. **Branch naming convention:**
   - `feat/<description>` - New features (e.g., `feat/add-vim-role`)
   - `fix/<description>` - Bug fixes (e.g., `fix/cursor-extensions`)
   - `refactor/<description>` - Code refactoring
   - `ci/<description>` - CI/CD changes
   - `docs/<description>` - Documentation updates
   - `test/<description>` - Test additions/updates

3. **Make your changes** following the testing workflow above

4. **Commit with conventional format:**
   ```bash
   git commit -m "type(scope): description"
   ```

5. **Push and create a Pull Request:**
   ```bash
   git push -u origin <branch-name>
   # Then create PR using mcp__github__create_pull_request
   ```

**Pull Request Requirements:**

- ✅ Must have a descriptive title using conventional commit format
- ✅ Must include a summary of changes in the description
- ✅ Must pass all CI checks (lint, test-roles, integration-test)
- ✅ Should reference related issues if applicable
- ✅ Molecule tests must pass for any modified roles

**What NOT to do:**

- ❌ Never commit directly to `main` branch for features
- ❌ Never skip CI checks or tests
- ❌ Never merge without passing CI
- ❌ Never use `git push --force` on `main`

**Merging:**

- PRs can be merged once all CI checks pass
- Use "Squash and merge" for clean commit history
- The squash commit message will trigger semantic-release on `main`
- A new version will be created automatically based on commit type

## Important Notes

### Initial Setup

Users must:

1. Run `./setup.sh` to install dependencies and Ansible (supports macOS, Ubuntu, and Debian)
   - macOS: Installs Homebrew and Ansible
   - Ubuntu/Debian: Installs Python 3, pip, and Ansible
2. Configure `hosts` file with their username
3. Edit `group_vars/all.yml` with personal settings (Git config, packages, etc.)

### macOS-Specific Requirements

- Command Line Tools must be installed first
- Terminal needs Full Disk Access for some operations
- Apple ID login required for App Store installations
- Rosetta 2 automatically installed on Apple Silicon Macs

### Ubuntu/Debian-Specific Requirements

- System must be updated first
- Git must be pre-installed (to clone the repository)
- Python3 and pip are automatically installed by `setup.sh`
- Uses snap for some application installations (Ubuntu)
- Uses direct downloads for some applications (Debian)

### Testing Limitations

Molecule tests run in containers, so some features cannot be tested:

- GUI applications (Cursor extensions, App Store apps)
- System settings modifications (macOS settings, Dock)
- Features requiring systemd or display servers

### File Operations

When modifying role tasks:

- Always maintain OS detection logic
- Keep `main.yml` as orchestrator, not implementation
- Put installation logic in `install-{{ ansible_os_family }}.yml`
- Put configuration logic in separate task files (e.g., `setup-settings.yml`)
- Define OS-specific variables in `vars/{{ ansible_os_family }}.yml`


### Release Management

This repository uses **semantic-release** for fully automated version management and package publishing.

**How it works:**

- Every push to `main` branch triggers the semantic-release workflow
- semantic-release analyzes commit messages to determine the version bump
- If a release is warranted, it automatically:
  1. Determines the new version number based on commit types
  2. Generates/updates CHANGELOG.md with categorized changes
  3. Creates a git tag
  4. Creates a GitHub release with release notes
  5. Sends Telegram notification

**Version Bumping Rules:**

| Commit Type | Version Bump | Example |
|-------------|--------------|---------|
| `feat:` | Minor (0.1.0 → 0.2.0) | New feature added |
| `fix:` | Patch (0.1.0 → 0.1.1) | Bug fix |
| `perf:` | Patch (0.1.0 → 0.1.1) | Performance improvement |
| `refactor:` | Patch (0.1.0 → 0.1.1) | Code refactoring |
| `chore(deps):` | Patch (0.1.0 → 0.1.1) | Dependency updates (Renovate) |
| `BREAKING CHANGE:` | Major (0.1.0 → 1.0.0) | Breaking API changes |
| `docs:`, `chore:`, `ci:`, `test:`, `style:` | No release | Documentation/maintenance |

**Configuration:**

- `.releaserc.json` - semantic-release configuration
- `.github/workflows/release.yml` - GitHub Actions workflow

**Important:**

- Releases are 100% automatic - no manual tagging needed
- Follow conventional commit format strictly
- Commits without release-triggering types won't create releases
- The workflow uses `[skip ci]` to avoid infinite loops when committing CHANGELOG

### Dependency Management with Renovate

This repository uses **Renovate** for automated dependency updates across multiple package managers.

**What Renovate manages:**

1. **npm dependencies** (package.json) - semantic-release and its plugins
2. **Python dependencies** (pyproject.toml) - Python packages managed by uv like `ansible`, `molecule`, `pre-commit`
3. **Ansible Galaxy roles** (requirements.yml) - Community roles like `elliotweiser.osx-command-line-tools`
4. **Ansible Galaxy collections** (requirements.yml) - Collections like `community.general`, `geerlingguy.mac`
5. **GitHub Actions** (.github/workflows/*.yml) - Third-party actions like `actions/checkout`, `actions/setup-node`

**Configuration highlights:**

- **Automated updates:** Renovate creates PRs for dependency updates automatically
- **Grouped updates:** Dependencies are grouped by type (npm, Python, Ansible collections, Ansible roles, GitHub Actions)
- **Auto-merge:** Minor and patch updates are auto-merged after CI passes
- **Manual review:** Major updates require manual approval (labeled with `major-update`)
- **Security alerts:** Vulnerabilities are flagged immediately with `security` label
- **Schedule:** Updates run weekly (Monday mornings before 6am Paris time)
- **Dependency Dashboard:** Track all pending updates in a single GitHub issue

**How it works:**

1. Every Monday, Renovate scans all dependency files
2. It creates grouped PRs for each dependency type
3. Minor/patch updates auto-merge if CI passes
4. Major updates wait for manual review
5. Security vulnerabilities trigger immediate PRs regardless of schedule
6. **When a PR is auto-merged**, the commit triggers semantic-release
7. **A new patch version is created** automatically (e.g., 1.1.0 → 1.1.1)
8. **CHANGELOG is updated** with the dependency changes
9. **Git tag and GitHub release** are created automatically

**Integration with semantic-release:**

- Renovate commits use the format `chore(deps): update <package_type>`
- This format triggers a **patch release** thanks to the `.releaserc.json` configuration
- Every auto-merged dependency update results in a new version
- Releases are created automatically without manual intervention
- Example: If Renovate updates npm packages on Monday, version bumps from 1.1.0 to 1.1.1

**Configuration files:**

- `renovate.json` - Renovate configuration at repository root
- Enabled datasources: npm, Python (pep621), Ansible Galaxy (roles & collections), GitHub Actions

**Important:**

- Renovate respects semantic versioning
- Conventional commits are used for dependency updates: `chore(deps): update npm dependencies`
- The Dependency Dashboard issue is automatically created and maintained
- You can trigger updates manually using dashboard checkboxes
- Pin GitHub Actions digests for better security

**Auto-merge Safety:**

Renovate is configured to auto-merge only when **ALL** CI checks pass:
- Uses GitHub's native auto-merge (`platformAutomerge: true`)
- Waits for required status checks before merging
- Respects branch protection rules automatically

**Required CI checks:**
- `lint` - Ansible linting and validation
- `test-roles` - Molecule tests for all roles
- `integration-test` - Full playbook integration test

**Setup:**

To enable Renovate on this repository:

1. **Install Renovate**
   - Install the [Renovate GitHub App](https://github.com/apps/renovate)
   - Grant it access to this repository
   - Renovate will automatically detect the `renovate.json` configuration
   - Review and merge the first onboarding PR

2. **Configure Branch Protection (CRITICAL for auto-merge)**
   - Go to: Settings → Branches → Add rule for `main`
   - Enable: "Require status checks to pass before merging"
   - Select required checks:
     - ✅ `lint`
     - ✅ `test-roles` (or individual role tests)
     - ✅ `integration-test`
   - Enable: "Require branches to be up to date before merging"
   - **Without branch protection, auto-merge will happen without waiting for CI!**

3. **Enable Auto-merge on Repository**
   - Go to: Settings → General → Pull Requests
   - Enable: "Allow auto-merge"
   - This allows Renovate to use GitHub's native auto-merge feature

### Commit conventions
- Use conventionnal commit format: `type(scope): subject`
- Each commit message is one line
- Do not take claude as author
- Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci, revert
- Use `BREAKING CHANGE:` in commit footer for major version bumps

## Active Technologies
- Ansible 2.15+ (YAML-based playbook automation) (001-claude-code-role)
- N/A (installation role, no persistent data storage) (001-claude-code-role)

## Recent Changes
- 001-claude-code-role: Added Ansible 2.15+ (YAML-based playbook automation)
