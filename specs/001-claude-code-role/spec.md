# Feature Specification: Claude Code Installation Role

**Feature Branch**: `001-claude-code-role`
**Created**: 2025-12-13
**Status**: Draft
**Input**: User description: "j'aimerai créér un role permettant d'installer claude-code. Le role doit pouvoir gérer MacOS, Debian et Ubuntu comme OS. Pour Mac l'installation se fera via homebrew. Pour Ubuntu et Debian, tu peux utiliser la méthode avec curl comme décrite dans la documentation"

**Constitution Compliance**: This feature specification MUST align with constitution principles (`.specify/memory/constitution.md`):
- Idempotency requirements
- OS-aware architecture (macOS + Ubuntu support)
- Test-first via Molecule
- Conventional commits & semantic versioning
- Single source configuration in group_vars/all.yml

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Install Claude Code on Fresh Workstation (Priority: P1)

As a developer setting up a new workstation, I want Claude Code to be automatically installed so that I can use it immediately after running the Ansible playbook.

**Why this priority**: This is the core functionality - without this, the role has no value. Users expect the tool to be installed and ready to use.

**Independent Test**: Can be fully tested by running the playbook on a fresh system and verifying Claude Code is installed and accessible via command line. Delivers immediate value by making Claude Code available.

**Acceptance Scenarios**:

1. **Given** a fresh macOS system with Homebrew installed, **When** the playbook runs with the claude-code role, **Then** Claude Code is installed via Homebrew and available in PATH
2. **Given** a fresh Ubuntu system, **When** the playbook runs with the claude-code role, **Then** Claude Code is installed via curl and available in PATH
3. **Given** a fresh Debian system, **When** the playbook runs with the claude-code role, **Then** Claude Code is installed via curl and available in PATH

---

### User Story 2 - Verify Installation Idempotency (Priority: P2)

As a developer re-running the playbook, I want the installation to be idempotent so that running it multiple times doesn't cause errors or unnecessary reinstallations.

**Why this priority**: Idempotency is a constitution requirement and ensures the playbook can be safely re-run without side effects.

**Independent Test**: Can be tested by running the playbook twice on the same system and verifying no changes are made on the second run (changed=0).

**Acceptance Scenarios**:

1. **Given** Claude Code is already installed on macOS, **When** the playbook runs again, **Then** no changes are made and the existing installation is preserved
2. **Given** Claude Code is already installed on Ubuntu, **When** the playbook runs again, **Then** no changes are made and the existing installation is preserved
3. **Given** Claude Code is already installed on Debian, **When** the playbook runs again, **Then** no changes are made and the existing installation is preserved

---

### User Story 3 - Enable/Disable Installation via Feature Flag (Priority: P3)

As a system administrator, I want to control whether Claude Code should be installed so that I can customize the playbook for different environments.

**Why this priority**: This provides flexibility for users who may not want Claude Code on all systems. It follows the pattern established by other roles.

**Independent Test**: Can be tested by setting the feature flag to false and verifying Claude Code is skipped during playbook execution.

**Acceptance Scenarios**:

1. **Given** the claude_code_enabled flag is set to true in group_vars, **When** the playbook runs, **Then** Claude Code is installed
2. **Given** the claude_code_enabled flag is set to false in group_vars, **When** the playbook runs, **Then** Claude Code installation is skipped
3. **Given** no claude_code_enabled flag is defined, **When** the playbook runs, **Then** Claude Code is installed by default

---

### Edge Cases

- **Homebrew not installed on macOS**: The role MUST check for Homebrew presence and fail with a clear error message directing users to ensure base-tools role has run first or Homebrew is installed manually
- **Network failures during curl installation**: The role MUST retry the download 3 times with appropriate delays before failing with a clear error message indicating network connectivity issues
- **Older version of Claude Code already installed**: The role MUST preserve the existing installation without forcing updates (idempotence) - Claude Code manages its own auto-updates
- **Unsupported OS versions** (macOS <10.15, Ubuntu <20.04, Debian <10): The role will attempt installation and let Homebrew or the curl installation script fail naturally with their own error messages (no explicit version checking)
- **curl installation script unavailable or returns an error**: Same retry behavior as network failures (3 attempts) before failing with error message

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST install Claude Code on macOS systems using Homebrew package manager
- **FR-002**: System MUST install Claude Code on Ubuntu systems using curl-based installation method
- **FR-003**: System MUST install Claude Code on Debian systems using curl-based installation method
- **FR-004**: System MUST detect the operating system family (Darwin for macOS, Debian for Ubuntu/Debian) to determine the installation method
- **FR-005**: System MUST be idempotent - running the installation multiple times MUST NOT cause errors or unnecessary changes, and MUST NOT force version updates if Claude Code is already installed
- **FR-006**: System MUST verify Claude Code is accessible in the system PATH after installation
- **FR-007**: System MUST support enabling/disabling installation via a `claude_code_enabled` configuration variable in group_vars/all.yml
- **FR-008**: System MUST skip installation gracefully when `claude_code_enabled` is set to false
- **FR-009**: System MUST provide appropriate error messages when installation fails
- **FR-010**: System MUST be testable in automated test environments for Ubuntu and Debian platforms
- **FR-011**: On macOS, system MUST verify Homebrew is installed before attempting Claude Code installation and fail with a clear error message if Homebrew is not found
- **FR-012**: On Ubuntu/Debian, system MUST retry curl-based installation up to 3 times on network or download failures before failing with a clear error message

### Key Entities

- **Claude Code Installation**: The installed CLI tool that must be accessible via command line
- **Operating System**: The platform (macOS, Ubuntu, Debian) that determines installation method
- **Installation Method**: Either Homebrew (macOS) or curl-based script (Ubuntu/Debian)
- **Feature Flag**: Configuration variable `claude_code_enabled` that controls whether installation occurs

### Dependencies and Assumptions

**Dependencies**:
- macOS systems require Homebrew package manager to be installed before running this role
- Ubuntu/Debian systems require curl to be available for installation
- All systems require internet connectivity to download Claude Code

**Assumptions**:
- Homebrew installation on macOS is managed by a separate role (base-tools)
- curl is available by default on Ubuntu/Debian systems
- Users have appropriate permissions to install system-wide tools
- Claude Code installation script follows standard conventions for PATH configuration
- Claude Code manages its own version updates via built-in auto-update mechanism (role does not manage updates)
- OS version compatibility is handled by the underlying installation tools (Homebrew, curl script) rather than explicit version checks in the role
- HTTPS/TLS connection security is sufficient for verifying authenticity of downloaded installation scripts (no additional checksum or signature verification required)

## Clarifications

### Session 2025-12-13

- Q: Comportement en cas d'échec de dépendance Homebrew - que faire si Homebrew n'est pas installé sur macOS? → A: Le rôle doit explicitement vérifier la présence de Homebrew et échouer avec un message clair si absent
- Q: Gestion des versions existantes de Claude Code - que faire si une ancienne version est déjà installée? → A: Préserver la version existante sans mise à jour forcée (idempotence stricte, Claude Code s'auto-update)
- Q: Gestion des échecs réseau pendant l'installation - comment gérer les échecs de téléchargement curl ou indisponibilité du script? → A: Retry automatique (3 tentatives) avant d'échouer avec message d'erreur
- Q: Gestion des versions d'OS non supportées - que faire sur macOS <10.15, Ubuntu <20.04, Debian <10? → A: Tenter l'installation quand même et laisser Homebrew/curl échouer naturellement
- Q: Vérification de l'intégrité des téléchargements - faut-il vérifier checksum/signature du script curl? → A: Faire confiance au HTTPS/TLS sans vérification supplémentaire (approche standard pour curl | bash)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully install Claude Code on all three supported operating systems (macOS, Ubuntu, Debian) by running the playbook
- **SC-002**: Installation completes in under 2 minutes on a standard internet connection
- **SC-003**: Running the playbook multiple times on the same system results in zero changes (changed=0) after the first successful installation
- **SC-004**: Claude Code command is immediately accessible from the command line after playbook execution without requiring manual PATH configuration
- **SC-005**: Automated tests pass for Ubuntu and Debian environments, validating installation correctness and idempotency
- **SC-006**: 100% of installation attempts either succeed with Claude Code available or fail with clear error messages
