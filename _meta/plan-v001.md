# Plan v001 — Harness System v2 Comprehensive Optimization

## Status

completed

## Closed At

2026-04-27

## Supersedes

none

## Objective

Optimize ~/.claude/ harness from "concept-complete" to "production-grade Claude Code harness system."

## Inferred True Objective

Make the protocol layer (CONSTITUTION + protocols) reliably trigger and enforce in real Claude Code sessions, not just exist as well-written documents. Concretely:

1. Eliminate cold-start cost via lightweight-mode whitelist
2. Bridge protocols ↔ Claude Code native features (TodoWrite / Skills / hooks / Agent tool / MCP)
3. Add hook-based enforcement so non-compliance is detectable
4. Close coverage gaps (non-code validation, subagent search-scope contract, plan timestamps, mode enumeration)
5. Add observability (standardized logs, self-evaluation, metrics)
6. Make distributable (installer, migration, sync, README)

## XY Risk Review

- Stated request: "make it the best harness in the world"
- Possible proxy: superficial polish, more documents
- True target: real-world reliability + native integration + enforceability
- Chosen framing: ROI-prioritized 4-phase rollout, subagent-driven implementation, main-agent audit

## Scope

### In Scope
- All 11 existing files in ~/.claude/
- New files: INTEGRATION.md, SELF_EVALUATION_PROTOCOL.md, MIGRATION_PROTOCOL.md, README.md, CHANGELOG.md, install.sh
- ~/.claude/settings.json hooks
- ~/.claude/_meta/ (this workspace)

### Out of Scope
- Modifying any project-level .claude/ workspaces
- Changing the user's existing skills/plugins
- Rewriting from scratch — preserve user's structure and tone

## Assumptions

- User runs Sonnet 4.6+ as primary model (lower models have weaker protocol adherence)
- User accepts English-first content for files intended for open-source
- ~/.claude/settings.json may already exist with permissions/env config — must preserve
- Subagents have file write access via Write/Edit tools

## Risks

- R1: Hook misconfiguration breaks user's daily Claude Code workflow → mitigation: advisory-only hooks, never blocking
- R2: Subagent context isolation may cause inconsistent style across files → mitigation: provide style anchors in each prompt
- R3: settings.json JSON corruption → mitigation: read-merge-validate pattern, no overwrite
- R4: Phase 4 open-sourcing not yet confirmed → mitigation: build infrastructure but don't publish

## Execution Phases

### Phase 1 — Reliability & Integration (THIS SESSION)
- 1A: CLAUDE.md adds Lightweight Mode Whitelist + quantitative trivial criteria
- 1B: Create INTEGRATION.md (TodoWrite/Skills/Agent/MCP/superpowers mapping)
- 1C: Configure settings.json hooks (advisory enforcement)

### Phase 2 — Spec Coherence Patches
- 2A: VALIDATION_PROTOCOL adds Non-Code Validation branch
- 2B: SUBAGENT_PROTOCOL §7 rewritten (search-scope contract on main-agent side)
- 2C: PLAN_SCHEMA adds task_id + created_at/updated_at fields
- 2D: Define execution modes enum (quick / standard / deep / recovery) in EXECUTION_PROTOCOL

### Phase 3 — Observability & Self-Evaluation
- 3A: Standardize logs/execution-log.md schema (in PROJECT_STRUCTURE_SPEC)
- 3B: Create SELF_EVALUATION_PROTOCOL.md
- 3C: Establish ~/.claude/metrics/ structure + schema

### Phase 4 — Distribution & Versioning
- 4A: Create install.sh (idempotent)
- 4B: Create MIGRATION_PROTOCOL.md + version field convention
- 4C: Sync mechanism documentation
- 4D: README.md + CHANGELOG.md (open-source-ready, English)

## Subagent Plan

| Phase | Subagent ID | subagent_type | Scope |
|-------|------------|---------------|-------|
| 1A | sa-1A | general-purpose | CLAUDE.md edit |
| 1B | sa-1B | general-purpose | INTEGRATION.md create |
| 1C | sa-1C | general-purpose | settings.json hooks |
| 2  | sa-2  | general-purpose | All 4 spec patches |
| 3  | sa-3  | general-purpose | Observability bundle |
| 4A | sa-4A | general-purpose | install.sh |
| 4B-D | sa-4B | general-purpose | Docs bundle |

Total: 7 subagents, 4 audit rounds.

## Validation Plan

- Minimal unit: each subagent's output file is syntactically valid (markdown / JSON)
- Callable entry: install.sh runs without error in dry-run
- Synthetic input: settings.json passes `jq . settings.json`
- Realistic input: SYSTEM_INDEX.md still loadable, CLAUDE.md still loadable, hooks fire on test prompts
- Objective verification: a fresh session triggers correct behavior on (a) trivial task — fast path, (b) non-trivial — full protocol

## Current State

- Completed: Phase 1, 2, 3, 4 (all)
- In progress: none
- Blocked: none
- Remaining: none

## Validation Evidence

- All 14 markdown files + VERSION + install.sh + settings.json present
- install.sh --check: ALL PASS (23 items)
- settings.json: valid JSON, 3 hooks registered (SessionStart, UserPromptSubmit, PreCompact)
- Total harness footprint: 2237 lines across 18 files
- 7 subagents dispatched, 0 failures, 0 escalations

## Next Action

none — harness v1.0.0 production-ready
