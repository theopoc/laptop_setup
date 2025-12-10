# Feature Specification: Complete Debian Compatibility

**Feature Branch**: `feat/debian-compatibility`
**Created**: 2025-12-09
**Status**: Draft
**Input**: User description: "project need to be also compatible with debian"

**Constitution Compliance**: This feature specification MUST align with constitution principles (`.specify/memory/constitution.md`):
- Idempotency requirements
- OS-aware architecture (macOS + Ubuntu + Debian support)
- Test-first via Molecule
- Conventional commits & semantic versioning
- Single source configuration in group_vars/all.yml

## Clarifications

### Session 2025-12-09

- Q: Which specific Debian 12 container image should be used for Molecule testing? → A: `geerlingguy/docker-debian12-ansible`

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Run Playbook on Debian System (Priority: P1)

A developer with a Debian workstation wants to use this Ansible playbook to set up their development environment with the same tools and configurations available on macOS and Ubuntu systems.

**Why this priority**: This is the core functionality. Without this, Debian users cannot use the playbook at all. It's the minimum viable product for Debian compatibility.

**Independent Test**: Can be fully tested by running the playbook on a Debian 12 system and verifying all roles execute without errors and produce the expected configurations.

**Acceptance Scenarios**:

1. **Given** a fresh Debian 12 installation, **When** user runs the full playbook, **Then** all roles complete successfully without errors
2. **Given** a Debian system with the playbook run once, **When** user runs the playbook again, **Then** idempotency is maintained (changed=0 for all tasks)
3. **Given** a Debian system, **When** user runs specific roles using tags, **Then** only the tagged roles execute and complete successfully

---

### User Story 2 - Validate Debian Support in CI Pipeline (Priority: P2)

The project maintainer wants automated testing to ensure Debian compatibility is maintained across all future changes, preventing regressions.

**Why this priority**: Automated testing prevents regressions and ensures quality. It's essential for long-term maintainability but can be added after basic functionality works.

**Independent Test**: Can be tested independently by running Molecule tests in Debian 12 containers and verifying all role tests pass.

**Acceptance Scenarios**:

1. **Given** Molecule configured with Debian 12 containers, **When** tests run in CI pipeline, **Then** all role tests pass
2. **Given** a pull request with role changes, **When** CI pipeline runs, **Then** Debian tests execute alongside Ubuntu tests
3. **Given** Debian-specific test failures, **When** reviewing CI results, **Then** failures are clearly identified as Debian-specific

---

### User Story 3 - Official Documentation and Support (Priority: P3)

Users browsing the repository want to know that Debian is officially supported and understand any Debian-specific installation steps or requirements.

**Why this priority**: Documentation is important for discoverability and user confidence, but the feature can work without perfect documentation initially.

**Independent Test**: Can be tested by reviewing README.md and CLAUDE.md to verify Debian is listed as supported and any Debian-specific prerequisites are documented.

**Acceptance Scenarios**:

1. **Given** a user reading README.md, **When** viewing supported operating systems, **Then** Debian is explicitly listed alongside macOS and Ubuntu
2. **Given** a user following installation instructions, **When** on Debian system, **Then** Debian-specific prerequisites (if any) are clearly documented
3. **Given** a contributor reading CLAUDE.md, **When** reviewing architecture patterns, **Then** Debian is included in OS-aware architecture examples

---

### Edge Cases

- What happens when a Debian version older than Debian 12 is used? (version compatibility)
- How does the system handle Debian derivative distributions (e.g., Raspberry Pi OS, Linux Mint Debian Edition)?
- What if a role requires packages available in Ubuntu but not in Debian repositories?
- How are architecture differences handled (arm64 vs amd64 on Debian)?
- What if Debian-specific package names differ from Ubuntu package names?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Playbook MUST successfully execute all roles on Debian 12 systems
- **FR-002**: Playbook MUST maintain idempotency on Debian (re-running produces no changes when no actual changes needed)
- **FR-003**: All roles with `molecule/` directories MUST have Molecule tests configured for Debian 12 containers using `geerlingguy/docker-debian12-ansible` image
- **FR-004**: Roles MUST detect Debian systems using `ansible_os_family` fact (value: "Debian")
- **FR-005**: Roles MUST load Debian-specific variables from `vars/Debian.yml` when running on Debian systems
- **FR-006**: Roles MUST include Debian-specific tasks from `tasks/install-Debian.yml` when running on Debian systems
- **FR-007**: Package installation tasks MUST use correct package names for Debian repositories
- **FR-008**: Configuration files and templates MUST work correctly on Debian systems
- **FR-009**: All tags (base-tools, cursor, mise, zsh, git, warp, vim, gpg, rancher-desktop, uv) MUST function on Debian
- **FR-010**: CI pipeline MUST execute Molecule tests against Debian 12 containers using `geerlingguy/docker-debian12-ansible` image
- **FR-011**: README.md MUST list Debian as a supported operating system
- **FR-012**: CLAUDE.md MUST include Debian in architecture documentation and examples
- **FR-013**: Constitution MUST reflect Debian support in OS-aware architecture principle

### Assumptions

- **Assumption 1**: Debian 12 (Bookworm) is the target version, as it's the current stable release
- **Assumption 2**: Most packages available in Ubuntu are also available in Debian repositories with same or similar names
- **Assumption 3**: Debian containers in Molecule tests will use `geerlingguy/docker-debian12-ansible` image (well-maintained, industry-standard for Ansible testing)
- **Assumption 4**: Debian-specific installation steps will be minimal and similar to Ubuntu in most cases
- **Assumption 5**: Existing Ubuntu/Debian detection logic (`ansible_os_family == 'Debian'`) may already work for Debian but needs verification
- **Assumption 6**: Architecture detection (`ansible_machine`) works identically on Debian and Ubuntu

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of roles execute successfully on Debian 12 systems without errors
- **SC-002**: Playbook demonstrates perfect idempotency on Debian (changed=0 on second run)
- **SC-003**: All Molecule tests pass in Debian 12 containers (0 failures)
- **SC-004**: CI pipeline completes successfully with Debian tests enabled
- **SC-005**: Installation time on Debian matches Ubuntu performance (within 10% variance)
- **SC-006**: README.md explicitly lists Debian in supported OS section
- **SC-007**: All 14+ roles with Debian-specific files have matching test coverage
- **SC-008**: No user-reported issues related to Debian incompatibility for 30 days post-release

### Key Entities

- **Role**: Individual Ansible role (cursor, git, zsh, etc.) requiring Debian-specific configuration
  - Attributes: Name, has_molecule_tests, debian_compatible_status
  - Relationships: Contains tasks, variables, templates

- **Operating System Configuration**: OS-specific settings for each role
  - Attributes: OS family (Darwin/Debian), package names, installation method, file paths
  - Relationships: Belongs to a role, determines which tasks/variables to include

- **Molecule Test Suite**: Container-based testing configuration
  - Attributes: Container image, test scenarios, verification assertions
  - Relationships: Tests a role, runs in CI pipeline
