# Implementation Plan: Complete Debian Compatibility

**Branch**: `feat/debian-compatibility` | **Date**: 2025-12-09 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-debian-compatibility/spec.md`

## Summary

This feature adds complete Debian 12 support to the Ansible playbook repository, enabling Debian users to provision their workstations with the same tools and configurations available on macOS and Ubuntu. The implementation follows the existing OS-aware architecture pattern, extends all roles with Debian-specific tasks/variables, updates Molecule tests to include Debian 12 containers, and updates documentation to reflect official Debian support.

**Key Deliverables**:
- Debian-specific installation tasks for all 14+ roles
- Molecule test configuration using `geerlingguy/docker-debian12-ansible` containers
- CI pipeline integration for automated Debian testing
- Updated documentation (README.md, CLAUDE.md, constitution)

## Technical Context

**Language/Version**: Ansible 2.15+ (current version in use), YAML for playbook/role definitions
**Primary Dependencies**:
- Ansible Core 2.15+
- Ansible Collections: `community.general`, `geerlingguy.mac`
- Molecule 6.x with Podman driver
- Container Image: `geerlingguy/docker-debian12-ansible`

**Storage**: File-based (Ansible playbooks, roles, variables stored in Git repository)
**Testing**: Molecule framework with Podman containers, ansible-lint for validation
**Target Platform**: Debian 12 (Bookworm) workstations, alongside existing macOS and Ubuntu support
**Project Type**: Infrastructure-as-Code (Ansible playbook repository)
**Performance Goals**:
- Playbook execution time on Debian within 10% of Ubuntu performance
- Molecule test suite completes in <15 minutes per role
- CI pipeline total runtime <30 minutes

**Constraints**:
- Must maintain backward compatibility with existing macOS and Ubuntu support
- Cannot introduce breaking changes to existing roles
- Must follow idempotent design (changed=0 on second run)
- Container-based testing only (no physical Debian machines in CI)

**Scale/Scope**: 14+ Ansible roles requiring Debian support, ~50 test scenarios, 3 OS platforms (macOS, Ubuntu, Debian)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature MUST comply with all principles from `.specify/memory/constitution.md`:

- [x] **Idempotency**: All Debian tasks will be designed idempotent following existing role patterns
- [x] **OS-Aware Architecture**: Feature explicitly adds Debian to existing Darwin/Ubuntu support structure
- [x] **Test-First via Molecule**: Molecule tests will be updated before implementation per TDD workflow
- [x] **Pull Request Workflow**: Feature developed on `feat/debian-compatibility` branch (compliant format)
- [x] **Conventional Commits**: Will use `feat(roles): add debian support` format for commits
- [x] **Single Source Configuration**: Debian variables added to existing `group_vars/all.yml` structure
- [x] **Simplicity**: Will reuse existing patterns, prefer native Ansible modules, avoid over-engineering
- [x] **Tagging**: All roles already tagged; Debian support doesn't require new tags
- [x] **Documentation**: README.md, CLAUDE.md, and constitution will be updated per FR-011, FR-012, FR-013

**Platform-Specific Exemptions**: None - Debian is a full platform addition, not a platform-specific exemption

**Complexity Justification**: No constitution violations - all principles satisfied

##Project Structure

### Documentation (this feature)

```text
specs/001-debian-compatibility/
├── plan.md              # This file
├── research.md          # Phase 0: Package mapping, container validation
├── role-inventory.md    # Phase 1: Complete role audit results
├── quickstart.md        # Phase 1: Debian testing guide
└── checklists/
    └── requirements.md  # Specification quality checklist
```

### Source Code (repository root)

This is an Ansible playbook repository with role-based structure:

```text
roles/
├── base-tools/
│   ├── tasks/
│   │   ├── main.yml              # Orchestrator
│   │   ├── install-Darwin.yml    # macOS (existing)
│   │   ├── install-Ubuntu.yml    # Ubuntu (existing - may need rename)
│   │   └── install-Debian.yml    # NEW: Debian-specific tasks
│   ├── vars/
│   │   ├── Darwin.yml            # macOS vars (existing)
│   │   ├── Ubuntu.yml            # Ubuntu vars (existing - may need rename)
│   │   └── Debian.yml            # NEW: Debian-specific vars
│   └── molecule/
│       └── default/
│           ├── molecule.yml      # ADD: Debian 12 platform
│           ├── converge.yml      # UPDATE: Test Debian scenario
│           └── verify.yml        # UPDATE: Verify Debian install
│
├── cursor/              # Same pattern for all 14+ roles
├── mise/
├── zsh/
├── git/
├── warp/
├── vim/
├── gpg/
├── rancher-desktop/
├── uv/
├── gita/
├── copier/
└── [additional roles...]

.github/workflows/
└── ci.yml               # UPDATE: Add Debian test jobs

README.md                # UPDATE: Add Debian to supported OS
CLAUDE.md                # UPDATE: Include Debian in examples
.specify/memory/constitution.md  # UPDATE: OS-Aware Architecture principle

group_vars/
└── all.yml              # May need Debian-specific package names
```

**Structure Decision**: Uses existing Ansible role-based structure. Each role follows the OS-aware architecture pattern with separate task files per OS family (`install-Darwin.yml`, `install-Debian.yml`). Debian support is added by creating parallel Debian-specific files alongside existing macOS and Ubuntu files.

**Key Architectural Note**: Ubuntu and Debian both use `ansible_os_family == 'Debian'` fact, so existing Ubuntu detection may already work for Debian. Research phase will verify if separate task files needed or if Ubuntu files can be renamed to `install-Debian.yml` and shared.

## Complexity Tracking

No constitution violations detected. Feature follows established patterns and principles.
