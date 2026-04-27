# Plan v002 — Praxis v1.1: Structural Artifacts for Meta-Decisions

## Status

active

## Plan ID

plan-praxis-v11-batch1-v001

## Created At

2026-04-27T07:00:00Z

## Updated At

2026-04-27T07:00:00Z

## Supersedes

none (extends plan-v001 which is completed)

## Objective

Convert three currently soft (self-attested) meta-decisions into hard (file-backed, auditable) structural artifacts.

## Inferred True Objective

Address three known LLM compliance failure modes in the current Praxis v1.0.1:

1. Mode under-classification bias — solved by mandatory rubric file (1B)
2. Completion-pressure validation skip — solved by closure-token format constraint (2A)
3. Constitutional violation invisibility — solved by article-tagged action log + mandatory non-empty skipped-rules (3A part-1; 3C deferred to batch 2)

The unifying principle: every meta-decision must produce a structural artifact that a future reviewer can audit. The harness already does this for strategy (plan-as-files); v1.1 extends it to meta-decisions.

## XY Risk Review

- Stated request: "implement these three mechanisms"
- Possible proxy: ceremonial "more files = better"
- True target: reduce three specific empirical failure modes
- Chosen framing: minimal additive structural changes to existing protocols, no new mandatory ceremony in lightweight mode

## Scope

### In Scope
- New file: `MODE_DECISION_SCHEMA.md` (global schema)
- Edits to: `CLAUDE.md`, `EXECUTION_PROTOCOL.md`, `VALIDATION_PROTOCOL.md`, `SELF_EVALUATION_PROTOCOL.md`, `PROJECT_STRUCTURE_SPEC.md`, `SYSTEM_INDEX.md`
- Updates to: `CHANGELOG.md`, `VERSION` (1.0.1 → 1.1.0)

### Out of Scope (deferred to v1.2 or later)
- 1A quantitative runtime escalation triggers (file/tool count overage auto-promotion)
- 2B two-stage close (closure-eligible vs closure-done)
- 2C context-budget guardrail (requires hook + utilization estimate)
- 3D phase-boundary audit subagent
- README rewrite (defer until v1.1 protocol stable)
- Settings.json hook updates (no new hooks needed for batch 1)

## Assumptions

- Existing v1.0.1 file structure is stable; all edits are additive or surgical
- Subagent (sonnet, medium effort) can hold the cross-file consistency in one task
- User accepts modest friction increase in standard/deep mode for non-trivial tasks (zero added friction in lightweight)

## Risks

- R1: Cross-file edits may introduce inconsistent vocabulary → mitigation: single-subagent dispatch (not parallel)
- R2: New rules may conflict with existing protocol text → mitigation: subagent reads ALL relevant files first, applies surgical patches
- R3: The "Skipped Rules must be non-empty" rule may produce performative honesty → accept; transparency over false purity is the explicit goal
- R4: Closure-token rule could collide with lightweight mode (no validation file required) → mitigation: token requirement scoped to standard/deep mode only

## Execution Phases

### Phase 1 — Single subagent dispatch
Deliver all three mechanisms in one consistent pass.

### Phase 2 — Audit
Main agent verifies:
- All file edits land at correct location
- New schema file follows existing schema conventions
- SYSTEM_INDEX registers new schema
- CHANGELOG reflects v1.1.0
- VERSION bumped
- No regression in v1.0.1 content

### Phase 3 — README rewrite + Push (user-approved, in progress)
Scope expanded per user 2026-04-27T08:50Z:
- Rewrite `README.md` with v1.1 design rationale: failure modes, philosophy, mechanisms, roadmap, residual risk, dogfood evidence
- Create `README.zh-CN.md` with same content in Chinese, cross-linked
- Update CHANGELOG entry under v1.1.0 to note documentation rewrite (no version bump — protocol unchanged)
- Sync to `~/claude-praxis/` working tree
- Commit and push to origin/main

Mode for Phase 3: standard (rubric: `_meta/mode-decisions/plan-praxis-v11-batch1-v001-phase3.md`)

Future-batch priority recorded per user instruction: 3D → 2B → 2C → 1A. Trigger: after v1.1 accumulates real-task data.

## Subagent Plan

| ID | Type | Model | Effort | Scope |
|----|------|-------|--------|-------|
| sa-v11-batch1 | general-purpose | sonnet | medium | 1B + 2A + 3A consolidated |

Single subagent because the three changes share vocabulary and cross-reference each other. Parallel dispatch would risk inconsistent terminology.

## Validation Plan

- Minimal unit: each modified file parses as markdown; new schema file conforms to schema-pattern of HANDOFF_SCHEMA / PLAN_SCHEMA
- Callable entry: `install.sh --check` still passes; `jq . settings.json` still valid (untouched)
- Synthetic input: simulate writing a mode-decision rubric, simulate a closure-token quote — verify format spec resolves
- Realistic input: cross-reference check — every newly added rule references the right counterpart file
- Objective verification: re-read CLAUDE.md as if a fresh agent — would it now write a mode-decision file in standard mode? Would it now refuse to claim closure without a token? Would it tag actions in execution-log with article IDs?

## Updated At

2026-04-27T07:30:00Z

## Current State

- Completed: Phase 1 (sa-v11-batch1), Phase 2 (audit)
- In progress: none
- Blocked: none
- Remaining: Phase 3 push — gated on explicit user approval

## Validation Evidence

See `_meta/validation/closure-praxis-v11-batch1-v001.md`.

## Next Action

Await user instruction on Phase 3 (push to ~/claude-praxis/ + git push).
