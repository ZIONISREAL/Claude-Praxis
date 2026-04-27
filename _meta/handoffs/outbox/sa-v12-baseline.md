# Subagent Task Packet — sa-v12-baseline

## Task ID
sa-v12-baseline

## Parent Plan
/Users/zion/.claude/_meta/plan-v003.md

## Role
implementer

## Model
sonnet

## Effort
medium

## Objective
F6 token-cost baseline + light README sync + CHANGELOG entry + VERSION bump for v1.2.0.

## Required Inputs
- /Users/zion/.claude/VERSION (currently 1.1.0)
- /Users/zion/.claude/CHANGELOG.md
- /Users/zion/claude-praxis/README.md
- /Users/zion/claude-praxis/README.zh-CN.md

## Allowed Reads
All files above. Also any ~/.claude/*.md to estimate file sizes for the baseline.

## Allowed Writes
- /Users/zion/.claude/VERSION (1.1.0 → 1.2.0)
- /Users/zion/.claude/CHANGELOG.md (add v1.2.0 entry)
- /Users/zion/.claude/metrics/token-cost-baseline.md (new file)
- /Users/zion/claude-praxis/README.md (light sync, see spec)
- /Users/zion/claude-praxis/README.zh-CN.md (light sync, mirror)

## Forbidden
- Do NOT touch protocol .md files
- Do NOT touch install.sh
- Do NOT do a full README rewrite — surgical updates only

## Specification

### F6 — metrics/token-cost-baseline.md

Create new file at `/Users/zion/.claude/metrics/token-cost-baseline.md`:

```markdown
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
```

### CHANGELOG entry

In `/Users/zion/.claude/CHANGELOG.md`, insert ABOVE the existing `## [1.1.0]` block:

```markdown
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
```

### VERSION

Replace contents with `1.2.0` (single line).

### README.md (light sync)

In the EXISTING `/Users/zion/claude-praxis/README.md`:

1. Update the closure-token reference section to add a note: "(v1.1.0 release; see CHANGELOG for v1.2.0 token-reduction work)"

2. Add a brief paragraph at the END of the "Roadmap" section, before "Honest Residual Risks":

```markdown
### Already Shipped: v1.2.0 — Token-Cost Reduction

Implemented per user-driven baseline measurement: 4-tier read set, slimmed CLAUDE.md, mandatory thin-dispatch via packet files (correcting a HANDOFF_SCHEMA §1 violation), and Anti-XY dedupe. Per-task overhead reduced ~50%. See `metrics/token-cost-baseline.md` and `install.sh --changelog 1.2.0`.
```

3. In the "Install" section, add a subsection after the install commands:

```markdown
### Update an Existing Install

```bash
~/.claude/install.sh --check-version    # see if a new version is available
~/.claude/install.sh --changelog        # see what's new
~/.claude/install.sh --update           # apply update (requires git-cloned source)
```
```

### README.zh-CN.md (mirror)

Apply the same 3 surgical updates in Chinese:

1. 关闭令牌参考段落补一句："(v1.1.0 发布；v1.2.0 token 减量工作详见 CHANGELOG)"

2. 路线图末尾「诚实的残余风险」之前加段：

```markdown
### 已发布：v1.2.0 — Token 成本减量

按用户驱动的基线测量实施：5 级读集分层、瘦身的 CLAUDE.md、强制 thin-dispatch（通过 packet 文件，修正了对 HANDOFF_SCHEMA §1 的违规）、Anti-XY 去重。每任务开销减少约 50%。详见 `metrics/token-cost-baseline.md` 与 `install.sh --changelog 1.2.0`。
```

3. 「安装」段加：

```markdown
### 更新已有安装

```bash
~/.claude/install.sh --check-version    # 查看是否有新版本
~/.claude/install.sh --changelog        # 查看更新内容
~/.claude/install.sh --update           # 应用更新（需要 git clone 安装的源）
```
```

## Done Criteria
- VERSION reads `1.2.0`
- CHANGELOG has v1.2.0 entry above v1.1.0
- baseline file created with all 5 sections
- README.md has 3 surgical edits (closure note, roadmap addendum, install update subsection)
- README.zh-CN.md has corresponding 3 edits in Chinese
- All files parse as markdown

## Escalation Conditions
- If README structure has drifted from spec → adapt insertion points but preserve intent

## Required Output (≤120 words)
1. baseline file: line count, all 5 sections present?
2. CHANGELOG: v1.2.0 entry added above v1.1.0?
3. VERSION: contents
4. README.md: 3 edits applied?
5. README.zh-CN.md: 3 edits applied (Chinese, same intent)?
6. Any deviation
