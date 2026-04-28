# Changelog

All notable changes to this harness.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.4.0] — 2026-04-28

### Added — Verification Layer
- `praxis` CLI tool implementing the third layer of execution discipline (verification)
- `RULE_REGISTRY.md` — stable public IDs for verification rules (6 stable + 5 provisional)
- `VERIFICATION_PROTOCOL.md` — three-layer model (externalization / reflection / verification)
- VALIDATION_PROTOCOL §11 closure token now supports optional `verifier=PASS|FAIL` field
- `praxis doctor` subcommands: check, verify-closure, lint, list-rules, explain

### Changed
- CLAUDE.md / AGENTS.md "Completion" sections recommend running `praxis doctor verify-closure` before issuing closure
- SYSTEM_INDEX Tier C now includes VERIFICATION_PROTOCOL and RULE_REGISTRY

### Rationale
v1.0–v1.3 produced visible execution state but relied on agent goodwill to actually verify it. The closure token's `last-line` check was format-detectable but not cryptographically enforced. v1.4 ships an external verifier (`praxis doctor`) that any agent or human can run to produce a PASS/FAIL judgment. The optional `verifier=` field on closure tokens captures the verdict for audit reproducibility.

### Architecture
The three-layer model is now testable: externalization (file exists) → reflection (file is read) → verification (file content is correct). The doctor enforces the third gate.

## [1.2.0] — 2026-04-27

### Added
- `install.sh --update` — one-command update for git-installed users
- `install.sh --check-version` — compare local VERSION against remote
- `install.sh --changelog [version]` — fetch CHANGELOG section
- `metrics/token-cost-baseline.md` — pre-v1.2 measurement reference
- SUBAGENT_PROTOCOL §11 — Thin-Dispatch Requirement (packet files for spec-heavy dispatches)
- HANDOFF_SCHEMA Thin-Dispatch Prompt Template

### Changed
- SYSTEM_INDEX read set restructured into 5 tiers (A–E); minimal tier is now 3 files instead of 7
- CLAUDE.md slimmed from ~121 lines to ~50, with detail moved to referenced protocols
- EXECUTION_PROTOCOL §3 (Anti-XY) now references CONSTITUTION §3 instead of duplicating

### Token Reduction Impact
Per-task overhead targeted from ~12K to ~5-6K tokens (~50% reduction). See `metrics/token-cost-baseline.md` for methodology and re-measurement plan.

### Rationale
User feedback identified that subagent dispatches inline full specs into prompts, copying that text into the main agent's running transcript and charging every subsequent message. This violated existing HANDOFF_SCHEMA §1 / SUBAGENT_PROTOCOL §6. v1.2 enforces the protocol via §11 and provides measurable optimization across four layers.

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
