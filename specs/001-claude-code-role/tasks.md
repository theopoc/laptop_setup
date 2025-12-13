# Tasks: Claude Code Installation Role

**Input**: Design documents from `/specs/001-claude-code-role/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Constitution Alignment**: Tasks MUST follow constitution principles (`.specify/memory/constitution.md`):
- Idempotent task design
- OS-aware architecture (Darwin + Debian support)
- Molecule tests REQUIRED (not optional) - converge.yml, verify.yml updates
- Ansible native modules preferred over shell/command
- Variables in group_vars/all.yml with role prefix

**Testing Strategy**: This project uses Molecule for container-based testing. Tests are MANDATORY for this role. Molecule tests validate idempotency and cross-platform behavior in Ubuntu 24.04 and Debian 12 containers.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Role initialization and basic structure

- [ ] T001 Create role directory structure at roles/claude-code/
- [ ] T002 Create defaults directory and main.yml at roles/claude-code/defaults/main.yml
- [ ] T003 [P] Create vars directory at roles/claude-code/vars/
- [ ] T004 [P] Create tasks directory at roles/claude-code/tasks/
- [ ] T005 [P] Create meta directory at roles/claude-code/meta/
- [ ] T006 [P] Create molecule test directory at roles/claude-code/molecule/default/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core configuration that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T007 Create default variables with claude_code_enabled: true in roles/claude-code/defaults/main.yml
- [ ] T008 [P] Create macOS-specific variables (package name, package manager) in roles/claude-code/vars/Darwin.yml
- [ ] T009 [P] Create Debian-specific variables (install URL, binary path) in roles/claude-code/vars/Debian.yml
- [ ] T010 Create role dependencies on base-tools (conditional on macOS) in roles/claude-code/meta/main.yml
- [ ] T011 Create main task orchestrator with OS detection in roles/claude-code/tasks/main.yml

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Install Claude Code on Fresh Workstation (Priority: P1) 🎯 MVP

**Goal**: Automatically install Claude Code on macOS, Ubuntu, and Debian systems so users can use it immediately after running the playbook

**Independent Test**: Run playbook on fresh system and verify Claude Code is installed and accessible via `claude --version`

### Molecule Tests for User Story 1 (MANDATORY) ⚠️

> **NOTE: Update Molecule tests FIRST, run `molecule test` to ensure they FAIL before implementation**

- [ ] T012 [P] [US1] Initialize Molecule scenario in roles/claude-code/ with `molecule init scenario default --driver-name podman`
- [ ] T013 [P] [US1] Configure Molecule platforms for Ubuntu 24.04 and Debian 12 in roles/claude-code/molecule/default/molecule.yml
- [ ] T014 [P] [US1] Create converge.yml playbook to execute claude-code role in roles/claude-code/molecule/default/converge.yml
- [ ] T015 [P] [US1] Create verify.yml with assertions: binary exists, is executable, runs --version in roles/claude-code/molecule/default/verify.yml

### Implementation for User Story 1

- [ ] T016 [US1] Implement macOS Homebrew check (FR-011) in roles/claude-code/tasks/install-Darwin.yml
- [ ] T017 [US1] Implement macOS Claude Code installation via Homebrew cask with state: present in roles/claude-code/tasks/install-Darwin.yml
- [ ] T018 [US1] Implement macOS Claude Code verification with `claude --version` in roles/claude-code/tasks/install-Darwin.yml
- [ ] T019 [US1] Implement Ubuntu/Debian binary existence check in roles/claude-code/tasks/install-Debian.yml
- [ ] T020 [US1] Implement Ubuntu/Debian curl installation with retry logic (FR-012: 3 retries, 5-second delay) in roles/claude-code/tasks/install-Debian.yml
- [ ] T021 [US1] Implement Ubuntu/Debian Claude Code verification with `~/.local/bin/claude --version` in roles/claude-code/tasks/install-Debian.yml
- [ ] T022 [US1] Update main.yml to include OS-specific variables and conditional installation tasks in roles/claude-code/tasks/main.yml
- [ ] T023 [US1] Add claude-code role to main playbook with tag support in main.yml
- [ ] T024 [US1] Run `molecule test` to verify first-run installation succeeds and binary is accessible

**Checkpoint**: At this point, User Story 1 should be fully functional - Claude Code installs on all three platforms

---

## Phase 4: User Story 2 - Verify Installation Idempotency (Priority: P2)

**Goal**: Ensure playbook can be re-run multiple times without errors or unnecessary reinstallations

**Independent Test**: Run playbook twice on same system and verify `changed=0` on second run

### Molecule Tests for User Story 2 (MANDATORY) ⚠️

- [ ] T025 [P] [US2] Update converge.yml to run role twice for idempotency test in roles/claude-code/molecule/default/converge.yml
- [ ] T026 [P] [US2] Add idempotency assertions to verify.yml: check second run shows changed=0 in roles/claude-code/molecule/default/verify.yml

### Implementation for User Story 2

- [ ] T027 [US2] Verify macOS Homebrew cask module idempotency (state: present preserves existing) in roles/claude-code/tasks/install-Darwin.yml
- [ ] T028 [US2] Verify Ubuntu/Debian curl installation uses `creates:` parameter for idempotency in roles/claude-code/tasks/install-Debian.yml
- [ ] T029 [US2] Verify Ubuntu/Debian stat check prevents re-execution when binary exists in roles/claude-code/tasks/install-Debian.yml
- [ ] T030 [US2] Run `molecule test` to verify idempotency: changed=0 on second run for both platforms

**Checkpoint**: At this point, User Stories 1 AND 2 work independently - installation is both functional and idempotent

---

## Phase 5: User Story 3 - Enable/Disable Installation via Feature Flag (Priority: P3)

**Goal**: Allow system administrators to control whether Claude Code is installed via configuration variable

**Independent Test**: Set `claude_code_enabled: false` in group_vars and verify installation is skipped

### Molecule Tests for User Story 3 (MANDATORY) ⚠️

- [ ] T031 [P] [US3] Add host_vars test scenarios: enabled=true, enabled=false, undefined in roles/claude-code/molecule/default/molecule.yml
- [ ] T032 [P] [US3] Update verify.yml to conditionally check installation based on feature flag in roles/claude-code/molecule/default/verify.yml

### Implementation for User Story 3

- [ ] T033 [US3] Add conditional `when: claude_code_enabled | bool` to OS-specific task includes in roles/claude-code/tasks/main.yml
- [ ] T034 [US3] Document claude_code_enabled variable usage in roles/claude-code/defaults/main.yml comments
- [ ] T035 [US3] Add example override to group_vars/all.yml with comment explaining usage
- [ ] T036 [US3] Run `molecule test` with different feature flag values to verify conditional behavior

**Checkpoint**: All user stories should now be independently functional - installation, idempotency, and feature flag control

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Documentation, optimization, and final validation

- [ ] T037 [P] Update README.md with claude-code in available tags list and usage examples
- [ ] T038 [P] Update CLAUDE.md with claude-code in roles with Molecule tests section
- [ ] T039 [P] Document role architecture (OS-aware pattern, Homebrew dependency) in CLAUDE.md
- [ ] T040 [P] Add installation methods documentation (Homebrew for macOS, curl for Ubuntu/Debian) in README.md
- [ ] T041 Code review: verify all tasks follow OS-aware architecture pattern in roles/claude-code/tasks/
- [ ] T042 Code review: ensure no redundant tasks, use conditionals efficiently in roles/claude-code/tasks/
- [ ] T043 Verify all error messages are clear and actionable in roles/claude-code/tasks/install-*.yml
- [ ] T044 Final `molecule test` run across all platforms to ensure all changes are idempotent
- [ ] T045 Final `ansible-lint` run to catch any best practice violations
- [ ] T046 Manual testing on macOS: verify Homebrew check, installation, and idempotency
- [ ] T047 Verify group_vars/all.yml has documented example of claude_code_enabled override

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion
  - User stories can proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after User Story 1 complete - Tests idempotency of US1 implementation
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Independent feature flag functionality

### Within Each User Story

1. Molecule tests MUST be written and FAIL before implementation
2. Molecule configuration before implementation tasks
3. OS-specific implementations (Darwin + Debian) can run in parallel
4. Verification tasks after implementation
5. Final `molecule test` run before story completion

### Parallel Opportunities

**Setup Phase (Phase 1)**:
- T003-T006 can all run in parallel (different directories)

**Foundational Phase (Phase 2)**:
- T008-T009 can run in parallel (different OS variable files)

**User Story 1 (Phase 3)**:
- T012-T015 can all run in parallel (different Molecule files)
- T016-T018 (macOS) parallel with T019-T021 (Debian) - different OS implementations

**User Story 2 (Phase 4)**:
- T025-T026 can run in parallel (different Molecule files)
- T027 (macOS) parallel with T028-T029 (Debian) - different OS implementations

**User Story 3 (Phase 5)**:
- T031-T032 can run in parallel (different Molecule files)

**Polish Phase (Phase 6)**:
- T037-T040 can all run in parallel (different documentation files)

---

## Parallel Example: User Story 1

```bash
# Launch all Molecule test configuration files together:
Task: "Configure Molecule platforms in molecule/default/molecule.yml"
Task: "Create converge.yml in molecule/default/converge.yml"
Task: "Create verify.yml in molecule/default/verify.yml"

# Launch macOS and Debian implementations in parallel:
Task: "Implement macOS installation in tasks/install-Darwin.yml"
Task: "Implement Debian installation in tasks/install-Debian.yml"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T006)
2. Complete Phase 2: Foundational (T007-T011) - CRITICAL - blocks all stories
3. Complete Phase 3: User Story 1 (T012-T024)
4. **STOP and VALIDATE**: Run `molecule test` to verify US1 works independently
5. Manual test on macOS to validate Homebrew installation
6. **MVP READY**: Claude Code installs on all three platforms

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → **MVP Deployment** ✅
3. Add User Story 2 → Test idempotency independently → Deploy/Demo
4. Add User Story 3 → Test feature flag independently → Deploy/Demo
5. Polish Phase → Final validation and documentation
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together (T001-T011)
2. Once Foundational is done:
   - **Developer A**: User Story 1 (T012-T024) - Core installation
   - **Developer B**: Can prepare User Story 3 Molecule tests (T031-T032) - Independent feature
3. After US1 complete:
   - **Developer A**: User Story 2 (T025-T030) - Idempotency tests (depends on US1)
   - **Developer B**: User Story 3 implementation (T033-T036)
4. Both developers collaborate on Polish phase (T037-T047)

---

## Test-First Workflow (Constitution Requirement)

**CRITICAL**: Molecule tests are MANDATORY, not optional. Follow this workflow:

### For Each User Story:

1. **Write Molecule tests FIRST**:
   - Update molecule/default/molecule.yml with platforms and host_vars
   - Create/update converge.yml to execute the role
   - Create/update verify.yml with assertions for expected behavior

2. **Verify tests FAIL**:
   - Run `molecule test` - it MUST fail (role not implemented yet)
   - If tests pass before implementation, tests are wrong

3. **Implement role tasks**:
   - Create/update OS-specific variables (vars/)
   - Create/update OS-specific installation tasks (tasks/install-*.yml)
   - Update main orchestrator (tasks/main.yml)

4. **Verify tests PASS**:
   - Run `molecule test` - it MUST pass (role implemented correctly)
   - Check idempotency: changed=0 on second run

5. **Commit and move to next story**

---

## Notes

- [P] tasks = different files, no dependencies, can run in parallel
- [Story] label maps task to specific user story (US1, US2, US3) for traceability
- Each user story should be independently completable and testable
- **Molecule tests are MANDATORY** - not optional like in general projects
- Test-first workflow: Write tests → See them fail → Implement → See them pass
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Run `ansible-lint` frequently to catch issues early
- Manual macOS testing required (containers can't test macOS-specific features)

---

## Task Count Summary

- **Phase 1 (Setup)**: 6 tasks
- **Phase 2 (Foundational)**: 5 tasks
- **Phase 3 (User Story 1)**: 13 tasks
- **Phase 4 (User Story 2)**: 6 tasks
- **Phase 5 (User Story 3)**: 6 tasks
- **Phase 6 (Polish)**: 11 tasks
- **Total**: 47 tasks

**Parallel Opportunities**: 18 tasks marked [P] can run in parallel within their phases

**MVP Scope**: Phases 1-3 (24 tasks) deliver a fully functional Claude Code installation role

**Independent Test Criteria**:
- **US1**: Claude Code installs and is accessible via `claude --version` on all platforms
- **US2**: Re-running playbook shows `changed=0` (idempotency verified)
- **US3**: Setting `claude_code_enabled: false` skips installation completely
