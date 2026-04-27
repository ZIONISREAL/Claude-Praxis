# Changelog

All notable changes to this harness.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0] — 2026-04-27

### Added — Structural Artifacts for Meta-Decisions
- `MODE_DECISION_SCHEMA.md` — new schema; mandatory rubric file in standard / deep / recovery modes
- VALIDATION_PROTOCOL §11 — closure token rule coupling completion claims to evidence at format level
- SELF_EVALUATION closure-token field
- PROJECT_STRUCTURE_SPEC §11 article-tagging convention for `execution-log.md`
- `_meta/mode-decisions/` documented in PROJECT_STRUCTURE_SPEC §12

### Changed
- CLAUDE.md "Completion Rule" requires closure token in non-lightweight modes
- EXECUTION_PROTOCOL §12 "Completion Criteria" requires closure token
- SELF_EVALUATION "Skipped Rules" must be non-empty in standard / deep / recovery
- EXECUTION_PROTOCOL §4 adds step 15 for article-tagged logging
- SYSTEM_INDEX adds MODE_DECISION_SCHEMA to default read set

### Documentation
- Bilingual README rewrite (`README.md` / `README.zh-CN.md`) — comprehensive design rationale: four LLM failure modes addressed, self-attestation→structural-artifact philosophy, mechanism-by-mechanism explanation (1B/2A/3A), validation evidence with verbatim closure token, prioritized roadmap (3D→2B→2C→1A), honest residual risks
- `_meta/plan-v002.md`, `_meta/mode-decisions/`, `_meta/validation/closure-praxis-v11-batch1-v001.md` shipped as dogfood traceability artifacts

### Rationale
Three failure modes addressed:
1. Mode under-classification bias — solved by mandatory rubric file (visible decision)
2. Completion-pressure validation skip — solved by syntactic closure token (cannot be paraphrased away)
3. Constitutional violation invisibility — solved by article tagging in execution log + forced honesty in skipped-rules

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
