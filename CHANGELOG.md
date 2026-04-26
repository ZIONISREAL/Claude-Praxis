# Changelog

All notable changes to this harness.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.1] — 2026-04-27

### Added
- SUBAGENT_PROTOCOL.md §10 — model and effort constraints (default `sonnet` / `medium`, with override + logging rules)
- HANDOFF_SCHEMA.md — Model and Effort fields in task packet template

## [1.0.0] — 2026-04-27

### Initial production release

#### Added
- CONSTITUTION.md — 13-section constitutional law
- CLAUDE.md — global entrypoint with execution mode classification
- SYSTEM_INDEX.md — routing index for context-budget-aware loading
- INTEGRATION.md — mapping to TodoWrite, Agent tool, Skills, MCP, superpowers
- EXECUTION_PROTOCOL.md — pre-execution review, anti-XY, mode-driven behavior
- SUBAGENT_PROTOCOL.md — search-scope contract on main-agent side
- VALIDATION_PROTOCOL.md — 6-level validation ladder + non-code branch
- COMPACT_PROTOCOL.md — pre/post compaction continuity
- SELF_EVALUATION_PROTOCOL.md — post-task self-audit
- HANDOFF_SCHEMA.md — task packet + result schemas
- PLAN_SCHEMA.md — versioned plan with id + timestamp fields
- PROJECT_STRUCTURE_SPEC.md — project-level workspace spec with structured logs
- PROJECT_WORKSPACE_INDEX_TEMPLATE.md
- MIGRATION_PROTOCOL.md — cross-version evolution + sync rules
- metrics/ — cross-session aggregation files
- settings.json hooks — SessionStart, UserPromptSubmit, PreCompact (all advisory)
- install.sh — idempotent installer with --check / --dry-run / --force
- README.md — public-facing overview
- VERSION — 1.0.0

#### Design highlights
- Mode-aware execution (lightweight / standard / deep / recovery)
- Hook-based advisory enforcement, never blocking
- Pseudonymous metrics, append-only
- Backward-compatible migration discipline from day one
