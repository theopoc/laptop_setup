<!--
Sync Impact Report:
- Version: 0.0.0 → 1.0.0
- Initial constitution creation based on project analysis
- Principles derived from CLAUDE.md and README.md
- Templates requiring updates:
  ✅ plan-template.md - Updated Constitution Check section
  ✅ spec-template.md - Aligned with testing requirements
  ✅ tasks-template.md - Aligned with Molecule testing workflow
- Follow-up: None - all placeholders filled
-->

# laptop_setup Constitution

## Core Principles

### I. Idempotency (NON-NEGOTIABLE)

Every Ansible role and task MUST be idempotent. Running the playbook multiple times MUST produce the same result without side effects. Re-execution MUST show "changed=0" when no actual changes are needed.

**Rationale**: Users need confidence that running the playbook won't break their working environment. Idempotency enables safe iteration, recovery from failures, and predictable outcomes.

### II. OS-Aware Architecture

Every role MUST support both macOS (Darwin) , Ubuntu and Debian unless explicitly documented as platform-specific. Roles MUST use `ansible_os_family` fact for OS detection, load OS-specific variables from `vars/{{ ansible_os_family }}.yml`, and include OS-specific tasks from `tasks/install-{{ ansible_os_family }}.yml`.

**Rationale**: The playbook's core value is cross-platform automation. Consistent architecture patterns reduce cognitive load and enable contributors to work across roles efficiently.

### III. Test-First via Molecule (NON-NEGOTIABLE)

All roles with `molecule/` directories MUST have passing Molecule tests before code is merged. When modifying a role:
1. Update role tasks/variables/templates
2. Update Molecule test files (converge.yml, verify.yml, molecule.yml)
3. Run `molecule test` until it passes
4. Verify idempotence (changed=0 on second run)

Tests run in Ubuntu 24.04 and Debian 12 containers using Podman. macOS-only roles (rosetta, macos_settings) are exempt from container testing but MUST be manually verified.

**Rationale**: Container-based testing catches Ubuntu compatibility issues before deployment. Test-driven workflow prevents regressions and validates cross-platform behavior.

### IV. Pull Request Workflow (NON-NEGOTIABLE)

All feature changes MUST go through Pull Requests. Direct commits to `main` branch are forbidden for features.

**Branch naming**: `<type>/<description>` (feat/, fix/, refactor/, ci/, docs/, test/)

**PR requirements**:
- Descriptive title using conventional commit format
- Summary of changes in description
- ALL CI checks passing (lint, test-roles, integration-test, pr-checks)
- Passing Molecule tests for modified roles

**Rationale**: PR workflow ensures code review, automated testing, and quality gates. Branch protection + CI prevents broken code from reaching production.

### V. Conventional Commits & Semantic Versioning

All commits MUST use conventional commit format: `type(scope): subject`

**Valid types**: feat, fix, docs, style, refactor, perf, test, chore, ci, revert

**Version bumping** (automated via semantic-release):
- `feat:` → Minor version (0.1.0 → 0.2.0)
- `fix:`, `perf:`, `refactor:` → Patch version (0.1.0 → 0.1.1)
- `chore(deps):` → Patch version (Renovate auto-merges)
- `BREAKING CHANGE:` → Major version (0.1.0 → 1.0.0)
- `docs:`, `chore:`, `ci:`, `test:` → No release

**Rationale**: Automated release management eliminates manual versioning errors. Conventional commits enable automatic changelog generation and semantic version determination.

### VI. Single Source of Truth Configuration

All user-configurable variables MUST be defined in `group_vars/all.yml`. Roles MUST NOT introduce role-specific configuration files outside this pattern. Role-specific variables MUST be prefixed with the role name (e.g., `cursor_extensions`, `git_username`). Boolean flags MUST use `_enabled` suffix (e.g., `cursor_mcp_enabled`).

**Rationale**: Centralized configuration reduces user confusion and enables quick customization. Consistent naming conventions prevent variable collisions and improve searchability.

### VII. Simplicity & Anti-Over-Engineering

Prefer Ansible native modules over shell/command/script tasks. Use loops to avoid redundant tasks. Only add complexity when justified by actual requirements. YAGNI (You Aren't Gonna Need It) applies - don't build for hypothetical future needs.

**Rationale**: Simple, readable playbooks are easier to maintain, debug, and understand. Native modules provide better error handling and cross-platform compatibility than shell commands.

## Automation & Quality Gates

### Continuous Integration

All pushes and PRs trigger automated CI pipeline:
- **Linting**: `ansible-lint` validates playbook syntax and best practices
- **Role Testing**: Molecule tests execute for all modified roles
- **Integration Testing**: Full playbook execution in Ubuntu container
- **PR Automation**: Title validation, label assignment, test coverage checks

**Required CI checks** (enforced by branch protection):
- `lint` - Ansible linting and validation
- `test-roles` - Molecule tests for all roles
- `integration-test` - Full playbook integration test
- `pr-checks` - PR automation checks

Branch protection MUST prevent merging until all checks pass.

### Automated Dependency Management

Renovate manages dependency updates across:
- npm dependencies (package.json)
- Ansible Galaxy roles (requirements.yml)
- Ansible Galaxy collections (requirements.yml)
- GitHub Actions (.github/workflows/*.yml)

**Auto-merge policy**: Minor/patch updates auto-merge when ALL CI checks pass. Major updates require manual review (labeled `major-update`). Security vulnerabilities trigger immediate PRs (labeled `security`).

**Integration with semantic-release**: Auto-merged Renovate PRs use `chore(deps):` format, triggering automatic patch releases.

### Pre-commit Hooks

Pre-commit hooks enforce quality standards:
- Trailing whitespace removal
- YAML syntax validation
- Ansible linting
- File encoding checks
- Large file prevention

Hooks run locally before commits and in CI to catch issues early.

## Development Workflow

### Role Structure Pattern

```
roles/<role_name>/
├── tasks/
│   ├── main.yml              # Orchestrator - OS detection & task inclusion
│   ├── install-Darwin.yml    # macOS installation logic
│   ├── install-Debian.yml    # Ubuntu/Debian installation logic (ansible_os_family=Debian)
│   └── setup-*.yml           # Common configuration tasks
├── vars/
│   ├── Darwin.yml            # macOS-specific variables
│   └── Debian.yml            # Ubuntu/Debian-specific variables (ansible_os_family=Debian)
├── templates/                # Jinja2 templates for config files
├── meta/main.yml             # Role dependencies
└── molecule/                 # Testing infrastructure
    └── default/
        ├── molecule.yml      # Test configuration (Ubuntu 24.04 + Debian 12 platforms)
        ├── converge.yml      # Playbook to test
        └── verify.yml        # Assertions
```

### Tagging Strategy

All roles MUST be tagged to enable selective execution:
- Tags match role names (e.g., `cursor`, `git`, `zsh`)
- Users run specific roles: `ansible-playbook main.yml --tags cursor`
- Multiple tags: `--tags cursor,git,warp`
- Available tags documented in README.md

### Error Handling

Use `block:` and `rescue:` for complex error scenarios. Handlers MUST only restart services when configuration changes. Failed tasks MUST provide clear error messages guiding users to resolution.

## Governance

### Constitution Authority

This constitution supersedes all other development practices. When conflicts arise between this document and other guidance, this constitution takes precedence.

### Amendment Process

Constitution amendments require:
1. Documented rationale for change
2. Impact analysis on existing roles and workflows
3. PR approval with constitution changes
4. Version bump following semantic versioning:
   - **MAJOR**: Breaking changes to principles, removed requirements, governance redefinitions
   - **MINOR**: New principles added, expanded guidance, new mandatory sections
   - **PATCH**: Clarifications, wording improvements, typo fixes

### Compliance Review

All PRs MUST verify compliance with constitution principles. Code reviewers MUST validate:
- Idempotency maintained
- OS-aware architecture followed
- Molecule tests pass (where applicable)
- Conventional commit format used
- Configuration changes in group_vars/all.yml
- Ansible native modules preferred over shell commands

### Platform-Specific Exemptions

macOS-only roles (rosetta, macos_settings) are exempt from container testing but MUST:
- Be clearly documented as macOS-only
- Be excluded from CI Molecule tests
- Include manual testing instructions
- Use `when: ansible_os_family == 'Darwin'` guards

Ubuntu-specific features MUST be tested in Molecule containers.

### Documentation Requirements

User-facing documentation in README.md MUST stay synchronized with:
- Available tags (when roles added/removed)
- Installation prerequisites (when dependencies change)
- Configuration options in group_vars/all.yml (when variables added)

Developer-facing documentation in CLAUDE.md MUST stay synchronized with:
- Role architecture patterns (when structure changes)
- Testing workflows (when Molecule configuration changes)
- CI/CD pipelines (when GitHub Actions updated)

**Version**: 1.0.0 | **Ratified**: 2025-12-09 | **Last Amended**: 2025-12-09
