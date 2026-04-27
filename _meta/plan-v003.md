# Plan v003 — Praxis v1.2.0: Update Command + Token-Cost Reduction

## Status

active

## Plan ID

plan-praxis-v12-v001

## Created At

2026-04-27T17:30:00Z

## Updated At

2026-04-27T17:30:00Z

## Supersedes

none (extends v1.1.0)

## Objective

Ship Praxis v1.2.0 with: (a) user-facing one-command update mechanism, (b) measurable per-task token reduction via four targeted optimizations, (c) baseline measurement for future evidence-driven evolution.

## Inferred True Objective

The harness has cumulative token cost of ~10-13K per non-trivial task today. User specifically called out that subagent dispatches are bloated. Root cause: I have been violating HANDOFF_SCHEMA §1 / SUBAGENT_PROTOCOL §6 by inlining packet content into Agent tool prompts instead of writing packet files. Correcting this single violation is the highest-impact change.

## XY Risk Review

- Stated request: "implement update command + reduce tokens"
- Possible proxy: micro-optimizations on doc length
- True target: fix the largest token leak (inlined subagent prompts) by enforcing the existing protocol; add update command; create baseline so future work is evidence-led
- Chosen framing: bundled v1.2.0 with F1-F6, dogfood F4 for v1.2.0 itself

## Scope

### In Scope (F1-F6)
- F1 install.sh: --update / --check-version / --changelog flags
- F2 SYSTEM_INDEX.md: 4-tier default read set
- F3 CLAUDE.md slim to ~50 lines (move detail to referenced protocols)
- F4 SUBAGENT_PROTOCOL.md / HANDOFF_SCHEMA.md: enforce thin-dispatch via packet files
- F5 EXECUTION_PROTOCOL.md / CONSTITUTION.md: dedupe Anti-XY (one canonical, others reference)
- F6 metrics/token-cost-baseline.md: per-tier measured baseline (today)
- Bilingual README sync to v1.2.0 (concise update, not full rewrite)
- CHANGELOG, VERSION (1.1.0 → 1.2.0)

### Out of Scope
- Q5 plan archival auto-rule (deferred; not enough data yet)
- Q6 self-eval terse format (deferred)
- Q7 Skill-ify (v1.3+ candidate)
- Q8 prompt-cache layout (v1.3+ candidate)
- Roadmap items 3D / 2B / 2C / 1A (gated on real-task data per user instruction)

## Assumptions

- Claude Code's Agent tool reads the prompt parameter directly; subagent does not get the user's transcript
- Writing a packet file before dispatch costs ~50 tokens (Write tool call); savings on main-thread context outweigh this
- F4 dogfood (use thin-dispatch for v1.2.0's own subagents) does not regress quality
- Existing v1.1.0 users will accept v1.2.0 changes as additive, not breaking

## Risks

- R1: Thin-dispatch packet file may be insufficiently self-contained → mitigation: HANDOFF_SCHEMA template includes all critical fields; subagent reads protocols via Allowed Reads
- R2: F3 CLAUDE.md slim may break read-confirmation directive → mitigation: keep directive at top, only move detail
- R3: install.sh --update without remote pin may pull breaking changes → mitigation: check VERSION compatibility, refuse if MAJOR mismatch without --force
- R4: F4 enforcement may slow dispatches too much → mitigation: only required for prompts > 1000 tokens; short dispatches stay inline

## Execution Phases

### Phase 1 — F4 dogfood: write packet files for v1.2.0's own subagents
Demonstrate the new pattern works.

### Phase 2 — Parallel subagent dispatch
- sa-v12-install: F1 install.sh update flags
- sa-v12-protocol: F2 + F3 + F4 + F5 protocol-level edits
- sa-v12-baseline: F6 baseline measurement + README sync + CHANGELOG

### Phase 3 — Audit
Each subagent's output verified by main agent.

### Phase 4 — Sync + Commit + Tag + Push
Sync ~/.claude/ → ~/claude-praxis/, commit, tag v1.2.0, push.

### Phase 5 — Closure
Closure token + plan close.

## Subagent Plan

| ID | Type | Model | Effort | Scope | Dispatch Pattern |
|----|------|-------|--------|-------|------------------|
| sa-v12-install | general-purpose | sonnet | medium | F1 install.sh | thin-dispatch (dogfood) |
| sa-v12-protocol | general-purpose | sonnet | medium | F2+F3+F4+F5 protocol edits | thin-dispatch (dogfood) |
| sa-v12-baseline | general-purpose | sonnet | medium | F6 + README sync + CHANGELOG | thin-dispatch (dogfood) |

All three dispatches will use thin-dispatch (`<300 token prompts pointing at packet files in _meta/handoffs/outbox/`). This validates F4 on the v1.2.0 release itself.

## Validation Plan

- Minimal unit: each modified file parses; install.sh `bash -n` clean; jq settings.json valid
- Callable entry: install.sh --check passes; install.sh --update --dry-run runs (against itself); install.sh --check-version reports current vs latest
- Synthetic input: simulate dispatch with new HANDOFF_SCHEMA template — verify packet renders correctly
- Realistic input: F4 dogfooded by Phase 2 dispatches themselves — measure prompt size reduction
- Objective verification: per-task token count baseline (F6) recorded; future v1.3 measurement compares against this

## Current State

- Completed: mode-decision rubric written
- In progress: Phase 1 (writing packet files for Phase 2 subagents)
- Blocked: none
- Remaining: Phase 1-5

## Next Action

Write three packet files at `_meta/handoffs/outbox/sa-v12-{install,protocol,baseline}.md`, then dispatch all three in parallel with thin prompts.
