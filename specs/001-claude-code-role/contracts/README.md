# API Contracts

**Feature**: Claude Code Installation Role
**Date**: 2025-12-13

## Not Applicable

This feature is an **Ansible role** for infrastructure automation, not an application with traditional API endpoints or GraphQL schemas.

### Why Contracts Don't Apply

Ansible roles do not expose:
- REST API endpoints
- GraphQL schemas
- RPC interfaces
- WebSocket connections

Instead, Ansible roles provide:
- **Tasks**: YAML-based automation scripts
- **Variables**: Configuration inputs (documented in `data-model.md`)
- **Facts**: Runtime information gathered from systems
- **Modules**: Pre-built Ansible modules (e.g., `homebrew_cask`, `shell`)

### "Contract" Equivalents in Ansible

The closest equivalents to API contracts in Ansible are:

1. **Role Interface** (documented in `data-model.md`):
   - Input variables (defaults/main.yml, vars/*.yml)
   - Expected Ansible facts (ansible_facts.os_family, ansible_env.HOME)
   - Registered variables (output from tasks)

2. **Task Contracts** (documented in `quickstart.md`):
   - Expected task behavior (idempotency, error handling)
   - Task tags for selective execution
   - Dependencies on other roles (meta/main.yml)

3. **Molecule Tests** (contracts/verification):
   - Molecule verify.yml acts as a "contract test"
   - Assertions verify expected outcomes (binary exists, is executable, runs correctly)
   - Idempotency tests verify no changes on second run

### Where to Find "Contract" Documentation

| Traditional API Contract | Ansible Equivalent | Location |
|-------------------------|-------------------|----------|
| OpenAPI schema | Role variables schema | `data-model.md` |
| GraphQL schema | Task dependencies | `quickstart.md` |
| Request/Response examples | Task examples | `quickstart.md` |
| Authentication | Feature flags | `defaults/main.yml` |
| Validation rules | Variable constraints | `data-model.md` |
| Integration tests | Molecule verify tests | `molecule/default/verify.yml` |

### Summary

For Ansible roles, the **data model** and **Molecule tests** serve as the contract specification. They define:

1. **Inputs**: What variables are required/optional
2. **Outputs**: What changes are made to the system
3. **Guarantees**: What the role promises (idempotency, cross-platform support)
4. **Verification**: How to test that the contract is met

See `data-model.md` for the complete role interface specification.
