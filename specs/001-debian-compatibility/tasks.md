# Tasks: Complete Debian Compatibility

**Input**: Design documents from `/specs/001-debian-compatibility/`
**Prerequisites**: plan.md, spec.md, research.md, role-inventory.md

**Constitution Alignment**: Tasks MUST follow constitution principles (`.specify/memory/constitution.md`):
- Idempotent task design (check-before-install pattern)
- OS-aware architecture (Darwin + Debian support via ansible_os_family)
- Molecule tests MANDATORY - converge.yml, verify.yml updates required
- Ansible native modules preferred over shell/command
- Variables in group_vars/all.yml with role prefix

**Testing Strategy**: This project uses Molecule for container-based testing with Podman driver. Molecule tests are MANDATORY for all roles with `molecule/` directories. Tests validate idempotency and cross-platform behavior in Debian 12 containers (`geerlingguy/docker-debian12-ansible`).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. Each story represents a complete, independently testable increment.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Validate existing Debian-compatible roles and prepare CI infrastructure

- [ ] T001 [P] Verify base-tools Molecule tests pass with Debian 12 container in roles/base-tools/
- [ ] T002 [P] Verify cursor Molecule tests pass with Debian 12 container in roles/cursor/
- [ ] T003 [P] Verify mise Molecule tests pass with Debian 12 container in roles/mise/
- [ ] T004 [P] Verify rancher-desktop Molecule tests pass with Debian 12 container in roles/rancher-desktop/
- [ ] T005 [P] Verify warp Molecule tests pass with Debian 12 container in roles/warp/
- [ ] T006 [P] Verify zsh Molecule tests pass with Debian 12 container in roles/zsh/
- [ ] T007 Investigate mise role: check if install-Ubuntu.yml can be removed in favor of install-Debian.yml in roles/mise/tasks/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core tools with zero dependencies that MUST be complete before dependent roles

**⚠️ CRITICAL**: No P2 roles (uv, copier, gita) can begin until P1 foundation roles are complete

- [x] T008 Create git role variables file in roles/git/vars/Debian.yml with git_package and git_credential_helper_default
- [x] T009 Create vim role variables file in roles/vim/vars/Debian.yml with vim_package and vim_group
- [x] T010 Create gpg role variables file in roles/gpg/vars/Debian.yml with gpg_packages list and gpg_config_dir

**Checkpoint**: Foundation ready - P1 role implementation can now begin in parallel

---

## Phase 3: User Story 1 - Run Playbook on Debian System (Priority: P1) 🎯 MVP

**Goal**: Enable Debian users to run the Ansible playbook on Debian 12 systems with all roles executing successfully. This includes implementing Debian support for all P1 foundation roles (git, vim, gpg) with zero dependencies.

**Independent Test**: Run full playbook on Debian 12 system, verify all P1 roles complete successfully, verify idempotency (changed=0 on second run), test selective role execution with tags.

### Molecule Tests for git Role (MANDATORY) ⚠️

> **NOTE: Update Molecule tests FIRST, run `molecule test` to ensure they FAIL before implementation**

- [x] T011 [P] [US1] Update roles/git/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T012 [P] [US1] Update roles/git/molecule/default/converge.yml with test variables (git_enabled, git_username, git_email, git_credential_helper)
- [x] T013 [P] [US1] Update roles/git/molecule/default/verify.yml to assert git is installed and git config is applied correctly

### Implementation for git Role

- [x] T014 [US1] Create roles/git/tasks/install-Debian.yml with apt installation of git package
- [x] T015 [US1] Verify roles/git/tasks/main.yml includes OS-specific installation tasks via include_tasks with ansible_os_family
- [x] T016 [US1] Run `cd roles/git && molecule test` to verify idempotency (changed=0 on second run)

### Molecule Tests for vim Role (MANDATORY) ⚠️

- [x] T017 [P] [US1] Update roles/vim/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T018 [P] [US1] Update roles/vim/molecule/default/converge.yml to test vim installation and .vimrc configuration
- [x] T019 [P] [US1] Update roles/vim/molecule/default/verify.yml to assert vim is installed, .vimrc exists with correct permissions

### Implementation for vim Role

- [x] T020 [US1] Create roles/vim/tasks/install-Debian.yml with apt installation of vim package
- [x] T021 [US1] Verify roles/vim/tasks/main.yml includes OS-specific installation tasks via include_tasks with ansible_os_family
- [x] T022 [US1] Run `cd roles/vim && molecule test` to verify idempotency (changed=0 on second run)

### Molecule Tests for gpg Role (MANDATORY) ⚠️

- [x] T023 [P] [US1] Update roles/gpg/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T024 [P] [US1] Update roles/gpg/molecule/default/converge.yml with test variables for GPG configuration (gpg_enabled)
- [x] T025 [P] [US1] Update roles/gpg/molecule/default/verify.yml to assert gnupg and gpg-agent are installed, gpg-agent.conf exists

### Implementation for gpg Role

- [x] T026 [US1] Create roles/gpg/tasks/install-Debian.yml with apt installation of gnupg, gpg-agent, pinentry-curses packages
- [x] T027 [US1] Verify roles/gpg/tasks/main.yml includes OS-specific installation tasks via include_tasks with ansible_os_family
- [x] T028 [US1] Run `cd roles/gpg && molecule test` to verify idempotency (changed=0 on second run)

### Integration Validation for User Story 1

- [ ] T029 [US1] Run full playbook test with P1 roles (git, vim, gpg) on Debian 12 container to verify integration
- [ ] T030 [US1] Verify tagged execution works: `ansible-playbook main.yml --tags git,vim,gpg` on Debian 12
- [ ] T031 [US1] Verify idempotency for full P1 playbook run (changed=0 on second execution)

**Checkpoint**: At this point, User Story 1 (P1 foundation roles) should be fully functional and independently testable on Debian 12

---

## Phase 4: User Story 1 Continued - P2 Dependent Roles (Priority: P1)

**Goal**: Complete User Story 1 by adding Debian support for P2 roles (uv, copier, gita) that depend on mise (already Debian-compatible).

**Independent Test**: Verify uv, copier, gita execute successfully on Debian 12 with mise prerequisite, verify idempotency, test selective execution.

**Dependencies**: Requires mise role (already Debian-compatible) to be validated on Debian 12.

### Molecule Tests for uv Role (MANDATORY) ⚠️

- [x] T032 [P] [US1] Update roles/uv/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T033 [P] [US1] Update roles/uv/molecule/default/converge.yml to ensure mise role runs before uv role
- [x] T034 [P] [US1] Update roles/uv/molecule/default/verify.yml to assert uv is available via mise and shell configuration is applied

### Implementation for uv Role

- [x] T035 [US1] Create roles/uv/vars/Debian.yml with uv_shell_config_paths for .bashrc and .zshrc
- [x] T036 [US1] Create roles/uv/tasks/install-Debian.yml to configure shell integration via `uv tool update-shell` (no installation needed, uses mise)
- [x] T037 [US1] Verify roles/uv/tasks/main.yml includes OS-specific tasks via include_tasks with ansible_os_family
- [x] T038 [US1] Run `cd roles/uv && molecule test` to verify idempotency (changed=0 on second run)

### Molecule Tests for copier Role (MANDATORY) ⚠️

- [x] T039 [P] [US1] Update roles/copier/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T040 [P] [US1] Update roles/copier/molecule/default/converge.yml to ensure mise and uv roles run before copier role
- [x] T041 [P] [US1] Update roles/copier/molecule/default/verify.yml to assert copier is in uv tool list and `copier --version` works

### Implementation for copier Role

- [x] T042 [US1] Create roles/copier/vars/Debian.yml with copier_dependencies (python3-pip, python3-venv)
- [x] T043 [US1] Create roles/copier/tasks/install-Debian.yml to install Python dependencies and verify uv availability
- [x] T044 [US1] Verify roles/copier/tasks/main.yml includes OS-specific tasks via include_tasks with ansible_os_family
- [x] T045 [US1] Run `cd roles/copier && molecule test` to verify idempotency (changed=0 on second run)

### Molecule Tests for gita Role (MANDATORY) ⚠️

- [x] T046 [P] [US1] Update roles/gita/molecule/default/molecule.yml to add debian12 platform using geerlingguy/docker-debian12-ansible image
- [x] T047 [P] [US1] Update roles/gita/molecule/default/converge.yml to ensure mise and uv roles run before gita role
- [x] T048 [P] [US1] Update roles/gita/molecule/default/verify.yml to assert gita is in uv tool list, gita config directory exists, and `gita --version` works

### Implementation for gita Role

- [x] T049 [US1] Create roles/gita/vars/Debian.yml with gita_config_dir path
- [x] T050 [US1] Create roles/gita/tasks/install-Debian.yml to verify uv availability and install gita using `uv tool install gita`
- [x] T051 [US1] Verify roles/gita/tasks/main.yml includes OS-specific tasks via include_tasks with ansible_os_family
- [x] T052 [US1] Run `cd roles/gita && molecule test` to verify idempotency (changed=0 on second run)

### Final Integration Validation for User Story 1

- [ ] T053 [US1] Run full playbook test with all 6 new Debian-supported roles (git, vim, gpg, uv, copier, gita) on Debian 12 container
- [ ] T054 [US1] Verify tagged execution works for all new roles: `ansible-playbook main.yml --tags git,vim,gpg,uv,copier,gita` on Debian 12
- [ ] T055 [US1] Verify complete playbook idempotency (all existing + new roles show changed=0 on second run)
- [ ] T056 [US1] Test playbook execution on physical Debian 12 system (if available) to validate container vs real system behavior

**Checkpoint**: User Story 1 is now complete - All 6 roles needing Debian support now have Debian compatibility, and full playbook runs successfully on Debian 12

---

## Phase 5: User Story 2 - Validate Debian Support in CI Pipeline (Priority: P2)

**Goal**: Integrate Debian 12 container testing into the CI/CD pipeline to ensure automated testing prevents regressions across all future changes.

**Independent Test**: Trigger CI pipeline, verify Debian 12 Molecule tests execute alongside Ubuntu 24.04 tests, verify all role tests pass, confirm failures are clearly identified as Debian-specific.

**Dependencies**: Requires User Story 1 (P1) to be complete - all roles must have Debian support implemented before CI integration.

### CI Pipeline Configuration

- [ ] T057 [US2] Update .github/workflows/ci.yml to add Debian 12 test job alongside existing Ubuntu 24.04 job
- [ ] T058 [US2] Configure CI to use Podman driver with geerlingguy/docker-debian12-ansible image for Debian tests
- [ ] T059 [US2] Add matrix strategy to run Molecule tests for all roles with Debian 12 platform
- [ ] T060 [US2] Configure CI to report Debian-specific test failures separately from Ubuntu failures
- [ ] T061 [US2] Add CI status badge for Debian 12 tests to README.md (optional but recommended)

### CI Validation

- [ ] T062 [US2] Trigger CI pipeline by pushing to feat/debian-compatibility branch
- [ ] T063 [US2] Verify lint job passes for all Ansible files
- [ ] T064 [US2] Verify test-roles job executes Molecule tests for all 14 roles (6 existing Debian + 6 new Debian + 2 macOS-excluded)
- [ ] T065 [US2] Verify integration-test job runs full playbook on Debian 12 container
- [ ] T066 [US2] Verify pr-checks job validates PR requirements and test coverage
- [ ] T067 [US2] Confirm all CI checks pass with green status

### CI Documentation

- [ ] T068 [P] [US2] Document CI pipeline Debian testing in .github/workflows/README.md or ci.yml comments
- [ ] T069 [P] [US2] Update CLAUDE.md with Debian CI testing workflow and troubleshooting guidance

**Checkpoint**: At this point, User Story 2 is complete - CI pipeline automatically tests Debian 12 compatibility alongside Ubuntu 24.04

---

## Phase 6: User Story 3 - Official Documentation and Support (Priority: P3)

**Goal**: Update all user-facing and developer-facing documentation to officially list Debian as a supported operating system with installation instructions and architecture examples.

**Independent Test**: Review README.md for Debian listed alongside macOS and Ubuntu, verify CLAUDE.md includes Debian in architecture examples, confirm constitution reflects three-OS support.

**Dependencies**: User Story 1 (P1) must be complete for accurate documentation. User Story 2 (P2) CI integration should ideally be complete for full documentation accuracy.

### User-Facing Documentation

- [ ] T070 [P] [US3] Update README.md "Supported Operating Systems" section to list Debian 12 (Bookworm) alongside macOS and Ubuntu
- [ ] T071 [P] [US3] Add Debian-specific prerequisites to README.md installation section (if any - likely minimal)
- [ ] T072 [P] [US3] Update README.md with Debian testing instructions using Molecule and Podman
- [ ] T073 [P] [US3] Add Debian 12 to README.md examples: `ansible-playbook main.yml -i hosts --ask-become-pass` (Debian context)

### Developer-Facing Documentation

- [ ] T074 [P] [US3] Update CLAUDE.md "Repository Overview" to mention three-OS support (macOS, Ubuntu, Debian)
- [ ] T075 [P] [US3] Update CLAUDE.md "Architecture" section with Debian examples in OS-aware pattern (install-Debian.yml)
- [ ] T076 [P] [US3] Update CLAUDE.md "Molecule Testing Strategy" to include Debian 12 container usage (geerlingguy/docker-debian12-ansible)
- [ ] T077 [P] [US3] Add Debian-specific troubleshooting section to CLAUDE.md (package availability, architecture differences)
- [ ] T078 [P] [US3] Update CLAUDE.md "Development Guidelines" with Debian compatibility checklist

### Constitution Update

- [ ] T079 [US3] Update .specify/memory/constitution.md "OS-Aware Architecture" principle to explicitly mention Debian alongside macOS and Ubuntu
- [ ] T080 [US3] Update constitution.md "Test-First via Molecule" to mention Debian 12 containers alongside Ubuntu 24.04
- [ ] T081 [US3] Update constitution.md "Role Structure Pattern" example to show install-Debian.yml alongside Darwin and Ubuntu (if Ubuntu mentioned)

### Variable Documentation

- [ ] T082 [US3] Review group_vars/all.yml to ensure all new Debian-specific variables are documented with comments
- [ ] T083 [US3] Add Debian configuration examples to group_vars/all.yml comments where applicable

**Checkpoint**: At this point, User Story 3 is complete - All documentation reflects official Debian 12 support

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements and validations that affect the entire Debian compatibility feature

### Code Quality & Optimization

- [ ] T084 [P] Review all 6 new install-Debian.yml files for redundant tasks, use loops where possible
- [ ] T085 [P] Verify all new Debian tasks follow idempotency patterns (check-before-install with stat)
- [ ] T086 [P] Ensure all new roles use native Ansible modules (apt, file, copy) over shell commands
- [ ] T087 Run `ansible-lint` on all modified roles to catch best practice violations

### Final Testing & Validation

- [ ] T088 Run complete Molecule test suite for all 14 roles with Debian 12 containers (includes 6 existing + 6 new)
- [ ] T089 Verify complete playbook idempotency across all roles (changed=0 on second run for entire playbook)
- [ ] T090 Test playbook on physical Debian 12 system to validate real-world behavior beyond containers
- [ ] T091 Test selective role execution with various tag combinations on Debian 12
- [ ] T092 Validate architecture detection works correctly on both amd64 and arm64 Debian systems (if accessible)

### Edge Case Validation

- [ ] T093 Test playbook behavior on Debian derivative distributions (e.g., Raspberry Pi OS) if accessible
- [ ] T094 Verify error handling for missing Debian packages (simulate unavailable packages)
- [ ] T095 Test playbook recovery after interruption (idempotency allows safe re-run)

### Release Preparation

- [ ] T096 [P] Review all commits follow conventional commit format (feat, fix, docs, chore)
- [ ] T097 [P] Ensure all commit messages reference Debian compatibility context
- [ ] T098 Verify branch name is constitution-compliant: feat/debian-compatibility
- [ ] T099 Prepare pull request description with feature summary, testing results, and breaking changes (if any)
- [ ] T100 Tag all new Molecule-tested roles in main.yml for selective execution (git, vim, gpg, uv, copier, gita)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately. Validates existing Debian-compatible roles.
- **Foundational (Phase 2)**: Depends on Setup validation. Creates variable files for P1 foundation roles (git, vim, gpg).
- **User Story 1 - P1 Roles (Phase 3)**: Depends on Foundational phase. Implements git, vim, gpg (zero dependencies).
- **User Story 1 - P2 Roles (Phase 4)**: Depends on Phase 3 completion AND mise validation. Implements uv, copier, gita.
- **User Story 2 (Phase 5)**: Depends on User Story 1 complete (all 6 roles Debian-compatible). CI integration.
- **User Story 3 (Phase 6)**: Depends on User Story 1 complete. Can proceed in parallel with User Story 2. Documentation updates.
- **Polish (Phase 7)**: Depends on all user stories complete. Final validation and release preparation.

### User Story Dependencies

- **User Story 1 (P1)**: FOUNDATIONAL - All other stories depend on this. Implements core Debian support for 6 roles.
  - Internal dependencies: P1 foundation roles (git, vim, gpg) → P2 dependent roles (uv, copier, gita)
- **User Story 2 (P2)**: Depends on User Story 1 complete. CI pipeline integration.
- **User Story 3 (P3)**: Depends on User Story 1 complete. Documentation updates. Can run parallel with US2.

### Within Each User Story

**User Story 1 (Phases 3-4)**:
1. Molecule tests (converge.yml, verify.yml, molecule.yml) MUST be written and FAIL before implementation
2. Variable files (vars/Debian.yml) before task files (tasks/install-Debian.yml)
3. Task files before Molecule test execution
4. Individual role validation before integration validation
5. P1 foundation roles (git, vim, gpg) BEFORE P2 dependent roles (uv, copier, gita)

**User Story 2 (Phase 5)**:
1. CI configuration before validation
2. CI validation before documentation

**User Story 3 (Phase 6)**:
1. All documentation tasks can run in parallel (marked [P])

### Parallel Opportunities

- **Phase 1 (Setup)**: All T001-T006 can run in parallel (different roles, independent validation)
- **Phase 2 (Foundational)**: T008, T009, T010 can run in parallel (different variable files)
- **Phase 3 (US1 - P1 Roles)**:
  - Molecule tests: T011-T013 (git), T017-T019 (vim), T023-T025 (gpg) can run in parallel
  - After tests fail, implementations run sequentially per role, but multiple developers can work on different roles in parallel
- **Phase 4 (US1 - P2 Roles)**:
  - Molecule tests: T032-T034 (uv), T039-T041 (copier), T046-T048 (gita) can run in parallel
  - After tests fail, implementations run sequentially per role, but multiple developers can work on different roles in parallel
- **Phase 6 (US3)**: T070-T073 (README), T074-T078 (CLAUDE.md) can run in parallel
- **Phase 7 (Polish)**: T084-T086 (code review tasks) can run in parallel

---

## Parallel Example: User Story 1 - P1 Roles (Phase 3)

```bash
# Launch all Molecule test updates in parallel for P1 foundation roles:
Task T011: "Update roles/git/molecule/default/molecule.yml to add debian12 platform"
Task T012: "Update roles/git/molecule/default/converge.yml with test variables"
Task T013: "Update roles/git/molecule/default/verify.yml to assert git installation"

Task T017: "Update roles/vim/molecule/default/molecule.yml to add debian12 platform"
Task T018: "Update roles/vim/molecule/default/converge.yml to test vim installation"
Task T019: "Update roles/vim/molecule/default/verify.yml to assert vim and .vimrc"

Task T023: "Update roles/gpg/molecule/default/molecule.yml to add debian12 platform"
Task T024: "Update roles/gpg/molecule/default/converge.yml with GPG test variables"
Task T025: "Update roles/gpg/molecule/default/verify.yml to assert gnupg installation"

# After Molecule tests FAIL (expected), implementations can proceed in parallel:
# Developer A: Implement git role Debian support (T014-T016)
# Developer B: Implement vim role Debian support (T020-T022)
# Developer C: Implement gpg role Debian support (T026-T028)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only - Phases 1-4)

1. Complete Phase 1: Setup (validate existing Debian roles)
2. Complete Phase 2: Foundational (create variable files for P1 roles)
3. Complete Phase 3: User Story 1 P1 Roles (git, vim, gpg)
4. Complete Phase 4: User Story 1 P2 Roles (uv, copier, gita)
5. **STOP and VALIDATE**: Test User Story 1 independently on Debian 12
6. Verify all 6 roles execute successfully, idempotency maintained, tags work correctly
7. **Deploy/Demo MVP**: Full Debian playbook support for all non-macOS roles

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 (all 6 roles) → Test independently → **Deploy/Demo (MVP!)**
3. Add User Story 2 (CI integration) → Test CI pipeline → Deploy/Demo
4. Add User Story 3 (documentation) → Review docs → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers (after Foundational phase):

1. **Team completes Phase 1-2 together** (Setup + Foundational)
2. **Phase 3-4 (User Story 1)**:
   - Developer A: git + vim roles
   - Developer B: gpg + uv roles
   - Developer C: copier + gita roles
3. **Phase 5-6 (Parallel)**:
   - Developer A: User Story 2 (CI integration)
   - Developer B: User Story 3 (documentation)
4. **Phase 7 (Polish)**: Team reviews together

---

## Notes

- [P] tasks = different files, no dependencies - can run in parallel
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Molecule tests MUST FAIL before implementing role changes (TDD workflow)
- Commit after each role completion or logical group
- Stop at any checkpoint to validate story independently
- Idempotency is CRITICAL - every task must support changed=0 on second run
- Use check-before-install pattern for all installation tasks
- Prefer native Ansible modules (apt, file, copy) over shell commands
- All variables must use role name prefix (git_, vim_, gpg_, etc.)

---

## Task Count Summary

- **Total Tasks**: 100 tasks
- **Phase 1 (Setup)**: 7 tasks (T001-T007)
- **Phase 2 (Foundational)**: 3 tasks (T008-T010)
- **Phase 3 (User Story 1 - P1)**: 21 tasks (T011-T031)
- **Phase 4 (User Story 1 - P2)**: 24 tasks (T032-T055) - Note: US1 continues from Phase 3
- **Phase 5 (User Story 2)**: 13 tasks (T057-T069)
- **Phase 6 (User Story 3)**: 14 tasks (T070-T083)
- **Phase 7 (Polish)**: 17 tasks (T084-T100)

### Tasks per User Story

- **User Story 1 (P1)**: 45 tasks (Phases 2-4: T008-T056) - Complete Debian support for 6 roles
- **User Story 2 (P2)**: 13 tasks (Phase 5: T057-T069) - CI pipeline integration
- **User Story 3 (P3)**: 14 tasks (Phase 6: T070-T083) - Documentation updates

### Parallel Opportunities Identified

- **Phase 1**: 6 parallel tasks (T001-T006)
- **Phase 2**: 3 parallel tasks (T008-T010)
- **Phase 3**: 9 parallel tasks (Molecule test updates for 3 roles)
- **Phase 4**: 9 parallel tasks (Molecule test updates for 3 roles)
- **Phase 6**: 9 parallel tasks (documentation updates)
- **Phase 7**: 3 parallel tasks (code review)
- **Total Parallel Opportunities**: 39 tasks can be parallelized

### Suggested MVP Scope

**MVP = User Story 1 Complete (Phases 1-4: T001-T056)**
- Validates existing 6 Debian-compatible roles
- Implements Debian support for 6 remaining roles (git, vim, gpg, uv, copier, gita)
- Full playbook runs successfully on Debian 12 with idempotency
- Enables Debian users to provision workstations immediately
- **Value**: Complete Debian compatibility, immediately usable by end users

**Post-MVP Enhancements**:
- User Story 2: Automated CI testing (prevents regressions)
- User Story 3: Official documentation (discoverability and confidence)
- Phase 7: Polish and optimization (quality improvements)

---

## Format Validation

✅ **All tasks follow checklist format**: `- [ ] [TaskID] [P?] [Story?] Description with file path`
✅ **Task IDs**: Sequential T001-T100 in execution order
✅ **[P] markers**: Applied to parallelizable tasks (different files, no dependencies)
✅ **[Story] labels**: Applied to all user story phase tasks (US1, US2, US3)
✅ **File paths**: Included in all implementation task descriptions
✅ **Checkpoint markers**: Added after each phase completion for validation gates
