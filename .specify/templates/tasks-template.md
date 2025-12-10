---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Constitution Alignment**: Tasks MUST follow constitution principles (`.specify/memory/constitution.md`):
- Idempotent task design
- OS-aware architecture (Darwin + Debian support)
- Molecule tests REQUIRED (not optional) - converge.yml, verify.yml updates
- Ansible native modules preferred over shell/command
- Variables in group_vars/all.yml with role prefix

**Testing Strategy**: This project uses Molecule for container-based testing. Unlike general projects, tests are MANDATORY for all roles with `molecule/` directories. Molecule tests validate idempotency and cross-platform behavior in Ubuntu 24.04 containers.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Setup database schema and migrations framework
- [ ] T005 [P] Implement authentication/authorization framework
- [ ] T006 [P] Setup API routing and middleware structure
- [ ] T007 Create base models/entities that all stories depend on
- [ ] T008 Configure error handling and logging infrastructure
- [ ] T009 Setup environment configuration management

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Molecule Tests for User Story 1 (MANDATORY for roles with molecule/) ⚠️

> **NOTE: Update Molecule tests FIRST, run `molecule test` to ensure they FAIL before implementation**

- [ ] T010 [P] [US1] Update molecule/default/converge.yml to test [role behavior/feature]
- [ ] T011 [P] [US1] Update molecule/default/verify.yml with assertions for [expected outcome]
- [ ] T012 [P] [US1] Add/update host_vars in molecule/default/molecule.yml for [new variables]

### Implementation for User Story 1

> **Ansible-specific**: Replace generic paths with role structure (tasks/install-Darwin.yml, tasks/install-Debian.yml, vars/, templates/)

- [ ] T013 [P] [US1] Create OS-specific variables in roles/[role_name]/vars/Darwin.yml
- [ ] T014 [P] [US1] Create OS-specific variables in roles/[role_name]/vars/Debian.yml
- [ ] T015 [US1] Implement macOS installation logic in roles/[role_name]/tasks/install-Darwin.yml
- [ ] T016 [US1] Implement Ubuntu installation logic in roles/[role_name]/tasks/install-Debian.yml
- [ ] T017 [US1] Create common configuration tasks in roles/[role_name]/tasks/setup-[feature].yml
- [ ] T018 [US1] Update main.yml orchestrator with OS detection and task inclusion
- [ ] T019 [US1] Add role variables to group_vars/all.yml with [role_name]_ prefix
- [ ] T020 [US1] Add role tag to main.yml for selective execution
- [ ] T021 [US1] Run `molecule test` to verify idempotency (changed=0 on second run)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Molecule Tests for User Story 2 (MANDATORY for roles with molecule/) ⚠️

- [ ] T022 [P] [US2] Update molecule/default/converge.yml to test [role behavior/feature]
- [ ] T023 [P] [US2] Update molecule/default/verify.yml with assertions for [expected outcome]

### Implementation for User Story 2

- [ ] T024 [P] [US2] Update OS-specific variables in roles/[role_name]/vars/Darwin.yml
- [ ] T025 [P] [US2] Update OS-specific variables in roles/[role_name]/vars/Debian.yml
- [ ] T026 [US2] Extend macOS installation logic in tasks/install-Darwin.yml
- [ ] T027 [US2] Extend Ubuntu installation logic in tasks/install-Debian.yml
- [ ] T028 [US2] Add new configuration tasks in tasks/setup-[feature].yml
- [ ] T029 [US2] Update group_vars/all.yml with new variables
- [ ] T030 [US2] Run `molecule test` to verify idempotency

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Molecule Tests for User Story 3 (MANDATORY for roles with molecule/) ⚠️

- [ ] T031 [P] [US3] Update molecule/default/converge.yml to test [role behavior/feature]
- [ ] T032 [P] [US3] Update molecule/default/verify.yml with assertions for [expected outcome]

### Implementation for User Story 3

- [ ] T033 [P] [US3] Update OS-specific variables in roles/[role_name]/vars/Darwin.yml
- [ ] T034 [P] [US3] Update OS-specific variables in roles/[role_name]/vars/Debian.yml
- [ ] T035 [US3] Extend macOS installation logic in tasks/install-Darwin.yml
- [ ] T036 [US3] Extend Ubuntu installation logic in tasks/install-Debian.yml
- [ ] T037 [US3] Add new configuration tasks in tasks/setup-[feature].yml
- [ ] T038 [US3] Run `molecule test` to verify idempotency

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T039 [P] Update README.md with new role, tags, and configuration options
- [ ] T040 [P] Update CLAUDE.md with role architecture and testing guidance
- [ ] T041 Code cleanup: remove redundant tasks, use loops where possible
- [ ] T042 Performance optimization: minimize handler triggers, use efficient modules
- [ ] T043 Final `molecule test` run to ensure all changes are idempotent
- [ ] T044 Final `ansible-lint` run to catch any best practice violations
- [ ] T045 Manual testing on macOS (if macOS-specific features added)
- [ ] T046 Verify all variables documented in group_vars/all.yml with comments

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
