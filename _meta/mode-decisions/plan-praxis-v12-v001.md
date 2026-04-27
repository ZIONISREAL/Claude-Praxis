# Mode Decision — plan-praxis-v12-v001

## Created At

2026-04-27T17:30:00Z

## Stated Request

Implement v1.2.0: update command + token-cost optimizations (F1-F6 bundle).

## Inferred True Objective

Reduce protocol overhead per non-trivial task from ~10K to ~4-5K tokens; add user-facing update command; correct the dispatch-pattern violation (F4) by enforcing thin-dispatch via HANDOFF_SCHEMA packet files. Establish a measurable baseline so future optimizations are evidence-driven.

## Rubric

| Criterion | Estimate | Trivial-bound | Trivial? |
|---|---|---|---|
| Files to modify | ~10 (install.sh, CLAUDE.md, SYSTEM_INDEX.md, EXECUTION_PROTOCOL, SUBAGENT_PROTOCOL, HANDOFF_SCHEMA, README × 2, CHANGELOG, VERSION + new baseline file) | ≤ 2 | no |
| Tool calls expected | ~30 (multi-subagent + audits + git) | ≤ 8 | no |
| Domains touched | 3 (protocol, install/CLI, documentation) | 1 | no |
| Touches production paths | yes (install.sh is user-facing) | no | no |
| Multi-phase | yes (implement → sync → push → tag) | no | no |
| Subagent dispatch needed | yes (multiple) | no | no |
| New architecture decision | yes (thin-dispatch pattern formalized) | no | no |
| Durable state needed beyond conversation | yes | no | no |

## All Trivial Columns Are "yes"?

no

## Risk Indicators

- Modifying install.sh — user-facing CLI; bugs visible immediately
- F3 CLAUDE.md slim is invasive — protocol-level change to entry doc; needs careful audit
- F4 thin-dispatch is a behavioral change in how I dispatch — must dogfood it for v1.2.0 itself to validate

## Selected Mode

deep

## Justification

Marked deep rather than standard because:
- New architecture decision (thin-dispatch pattern in F4)
- Tool-call estimate ~30 exceeds standard threshold
- Multiple parallel subagent dispatches required
- v1.2.0 is the second formal release; quality bar is higher

Deep mode adds: explicit risk file (this section), mandatory subagent decomposition (F1-F4 split across subagents), mandatory plan v-bumping on direction change.

## Re-Classification Triggers

- If F4 dogfood reveals thin-dispatch causes subagent quality regression → halt, revert F4, ship v1.2.0 without it
- If install.sh changes break --check on existing v1.1.0 installs → escalate to recovery, fix backward compat
- If token-baseline measurement reveals optimizations don't actually save tokens → reassess Q1-Q4 priority

## Re-classifications

(none yet)
