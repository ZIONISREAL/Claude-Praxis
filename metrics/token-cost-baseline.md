# Token Cost Baseline — Praxis v1.1.0 (pre-v1.2 measurement)

Recorded: 2026-04-27
Measurement basis: file character counts ÷ 4 (rough English token estimate); subagent prompts measured from observed dispatches in plan-v002 / plan-v003 conversation history.

## Methodology

These are estimates, not exact API counts. The intent is to establish a reproducible reference point so v1.2 (and later) can claim measurable improvement.

Token-per-character ratio assumed: 0.25 (typical for English / mixed code-text).

## Tier 1 — Always-On (every Claude Code session)

| Source | Chars | Est. tokens |
|---|---|---|
| CLAUDE.md auto-load | ~3400 | ~850 |
| SessionStart hook output | ~200 | ~50 |
| **Subtotal** | | **~900** |

## Tier 2 — Per Non-Trivial Task (default read set)

| Source | Chars | Est. tokens |
|---|---|---|
| SYSTEM_INDEX.md | ~600 | ~150 |
| CONSTITUTION.md | ~4100 | ~1025 |
| INTEGRATION.md | ~4100 | ~1025 |
| EXECUTION_PROTOCOL.md | ~3700 | ~925 |
| PROJECT_STRUCTURE_SPEC.md | ~7000 | ~1750 |
| PLAN_SCHEMA.md | ~1600 | ~400 |
| MODE_DECISION_SCHEMA.md | ~2200 | ~550 |
| VALIDATION_PROTOCOL.md | ~2800 | ~700 |
| **Subtotal** | | **~6525** |

## Tier 3 — Per Subagent Dispatch (current inline pattern)

| Source | Chars | Est. tokens |
|---|---|---|
| Inline task spec in Agent prompt (typical for spec-heavy task) | ~6000-15000 | ~1500-3750 |
| Subagent's read of allowed files | varies | ~2000-4000 |
| Result return | ~600 | ~150 |
| **Per dispatch (typical)** | | **~3500-7500** |

Cost note: inline prompts persist in MAIN agent's transcript and are re-tokenized on every subsequent message. With N=20 messages and 5K-token prompt, that is 100K marginal tokens charged.

## Tier 4 — Closure (per non-trivial task)

| Source | Chars | Est. tokens |
|---|---|---|
| Validation file write | ~1000 | ~250 |
| Self-eval entry | ~800 | ~200 |
| Closure token quote | ~250 | ~60 |
| **Subtotal** | | **~510** |

## Aggregate per non-trivial task (with 1 subagent)

| Layer | Tokens |
|---|---|
| Tier 2 | ~6525 |
| Tier 3 (1 dispatch) | ~5000 |
| Tier 4 | ~510 |
| **Total** | **~12,035** |

## Daily estimate (10 non-trivial tasks, 3 subagent dispatches, 3 sessions)

| Layer | Tokens |
|---|---|
| Tier 1 (3 sessions) | ~2700 |
| Tier 2 (10 tasks) | ~65,250 |
| Tier 3 (3 dispatches × 5K) | ~15,000 |
| Tier 4 (10 tasks × 510) | ~5100 |
| **Daily total** | **~88,000** |

At Sonnet 4.6 input pricing ($3/MTok): **~$0.26/day per heavy user.** Annualized: ~$95/year.

## v1.2.0 Targets

| Optimization | Target reduction |
|---|---|
| F2 4-tier read set | -3000 to -4000 tokens per task (Tier A only = 2500 tokens vs Tier all = 6525) |
| F3 CLAUDE.md slim | -500 tokens always-on |
| F4 thin-dispatch | -3000 to -5000 tokens per subagent dispatch (in main transcript) |
| F5 Anti-XY dedupe | -300 tokens per Tier 2 read |

Combined target: per-task overhead from ~12K to ~5-6K tokens (50% reduction).

## Re-measurement Schedule

After v1.2 ships and 5+ real tasks have been recorded in `protocol-adherence.tsv`, append a v1.2 measurement section to this file.
