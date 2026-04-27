# Subagent Task Packet — sa-v12-protocol

## Task ID
sa-v12-protocol

## Parent Plan
/Users/zion/.claude/_meta/plan-v003.md

## Role
implementer

## Model
sonnet

## Effort
medium

## Objective
Apply four token-reduction protocol edits (F2-F5) across the harness. Each edit is surgical; no structural rewrites.

## Required Inputs
- /Users/zion/.claude/CLAUDE.md
- /Users/zion/.claude/SYSTEM_INDEX.md
- /Users/zion/.claude/EXECUTION_PROTOCOL.md
- /Users/zion/.claude/SUBAGENT_PROTOCOL.md
- /Users/zion/.claude/HANDOFF_SCHEMA.md
- /Users/zion/.claude/CONSTITUTION.md (read for §3 reference; do NOT modify)

## Allowed Reads
All files above + any other ~/.claude/*.md needed for cross-reference.

## Allowed Writes
- CLAUDE.md (slim)
- SYSTEM_INDEX.md (4-tier read set)
- SUBAGENT_PROTOCOL.md (add §11)
- HANDOFF_SCHEMA.md (add thin-dispatch template)
- EXECUTION_PROTOCOL.md (dedupe §3)

## Forbidden
- Do NOT touch CONSTITUTION.md (immutable behavioral law)
- Do NOT touch any file outside Allowed Writes
- Do NOT bump VERSION (handled by sa-v12-baseline)
- Do NOT modify CHANGELOG (handled by sa-v12-baseline)

## Specification

### F2 — SYSTEM_INDEX.md: 4-tier read set

REPLACE the existing `## Default Read Set` section AND its sub-sections (everything from `## Default Read Set` through to the line before `## Project-Level Next Step`) with:

```markdown
## Tiered Read Sets

Read only the tier required for the task. Most non-trivial tasks need only Tier A.

### Tier A — Minimal (any non-trivial task)

- `CONSTITUTION.md`
- `EXECUTION_PROTOCOL.md`
- `MODE_DECISION_SCHEMA.md`

### Tier B — Add when subagents will be dispatched

- `SUBAGENT_PROTOCOL.md`
- `HANDOFF_SCHEMA.md`

### Tier C — Add when closure is formal (standard / deep / recovery)

- `VALIDATION_PROTOCOL.md`
- `SELF_EVALUATION_PROTOCOL.md`
- `PLAN_SCHEMA.md`

### Tier D — Add when first creating a project workspace

- `PROJECT_STRUCTURE_SPEC.md`
- `INTEGRATION.md`

### Tier E — Add when context compaction is imminent

- `COMPACT_PROTOCOL.md`
```

Update the read confirmation directive's example to reference tier names instead of literal lists:
- Replace `[列出实际选择的文档]` with `[Tier A / A+B / A+B+C ...]`

### F3 — CLAUDE.md slim to ~50 lines

REPLACE the entire current contents (preserve the file but rewrite body) with:

```markdown
# CLAUDE.md

Global entrypoint for Claude Code execution.

**【读取确认指令】读完此文档后，必须立即在回复开头汇报：「✅ 已读取 CLAUDE.md」**

## Mandatory Read Order

1. Read `SYSTEM_INDEX.md`
2. Load only the tier(s) it specifies for current task
3. If repo has `.claude/WORKSPACE_INDEX.md`, read it
4. Read project files only if listed in WORKSPACE_INDEX active read set

## Identity

You are not a passive instruction follower. Operate as: critical interpreter of intent, anti-XY detector, plan-first executor for non-trivial work, file-based memory steward, validator before claiming completion.

## Mode Classification (Must State at Task Start)

State one: `Mode: lightweight | standard | deep | recovery`. Default one tier higher when uncertain. See `EXECUTION_PROTOCOL.md` §5 for full rubric. For standard/deep/recovery, write a mode-decision rubric at `<repo>/.claude/_meta/mode-decisions/<plan-id>.md` per `MODE_DECISION_SCHEMA.md` BEFORE first action.

## Non-Negotiable Rules

- Do not optimize bad premises into polished wrong results
- Do not proceed with non-trivial work without plan-as-files
- Do not rely only on conversational memory for durable state
- Do not declare completion without validation evidence
- Do not let subagents work without scoped file-based handoffs (per `HANDOFF_SCHEMA.md`)

## Completion

A non-trivial task is complete only when validation evidence exists AND a Closure Token per `VALIDATION_PROTOCOL.md` §11 is included in the completion claim. Lightweight mode: no token needed.

## Read Confirmation Convention

When this file or `SYSTEM_INDEX.md` is loaded, first line of next reply:
- `✅ 已读取 CLAUDE.md`
- `✅ 已读取 SYSTEM_INDEX.md，本次执行将载入：[Tier list]`
```

Target: ~45-55 lines. The original detailed sections are now distributed across EXECUTION_PROTOCOL.md, VALIDATION_PROTOCOL.md, MODE_DECISION_SCHEMA.md — all referenced.

### F4 — Thin-Dispatch enforcement

In SUBAGENT_PROTOCOL.md, append after existing §10 (Model and Effort Constraints):

```markdown
## 11. Thin-Dispatch Requirement

For any subagent task whose specification exceeds 1000 characters, the main agent MUST:

1. Write the full task packet (per `HANDOFF_SCHEMA.md` §1) as a file at `<repo>/.claude/handoffs/outbox/<task-id>.md` (or `~/.claude/_meta/handoffs/outbox/<task-id>.md` for harness-meta work).

2. Dispatch with a thin prompt of ≤ 300 tokens, structured as:

```
Effort: medium. Do not invoke extended thinking.
Task packet: <absolute path to packet file>
Read the packet, execute per its Specification section, report per its Required Output section.
```

For tasks with specifications ≤ 1000 characters, inline dispatch is permitted.

### Why This Rule Exists

Inlining a 5K-token specification into the Agent tool prompt copies that text into the main agent's running transcript, charging every subsequent conversation message for re-reading it. Writing the packet as a file shifts the cost to a one-time read by the subagent, keeps the main transcript lean, and produces an auditable handoff record per CONSTITUTION §V (durable state).

### Verification

A dispatch is non-compliant if the prompt exceeds 300 tokens AND the spec exceeds 1000 characters. Audit subagents and self-evaluation should flag this.
```

In HANDOFF_SCHEMA.md, after the existing §1 Subagent Task Packet template, append:

```markdown
### Thin-Dispatch Prompt Template

When dispatching a packet file, the main agent's Agent tool prompt should be:

```
Effort: medium. Do not invoke extended thinking. Do not skip reasoning.
Task packet: <absolute-path>
Read the packet, execute per its Specification section, report per its Required Output section.
```

The packet file at `<absolute-path>` is the authoritative source of constraints, allowed reads/writes, and done criteria. The thin prompt is just a pointer.
```

### F5 — Dedupe Anti-XY

In EXECUTION_PROTOCOL.md, REPLACE the entire current §3 ("Anti-XY Enforcement") with:

```markdown
## 3. Anti-XY Enforcement

See `CONSTITUTION.md` §3 (Anti-XY and Anti-GIGO Law) for the canonical rule. Operationally, the agent must:

1. Identify the literal request and the inferred true objective.
2. State any divergence to the user.
3. Proceed under the corrected framing if safe; otherwise support the literal request with explicit warning.

Do not optimize bad premises into polished wrong results.
```

Reduces ~15 lines of duplicated text to 5 lines that reference the canonical source.

## Done Criteria
- All 4 patches applied per spec
- No file outside Allowed Writes modified
- All edited files parse as markdown
- Line count delta:
  - CLAUDE.md: ~121 → ~50
  - SYSTEM_INDEX.md: stays similar (~50-60 lines)
  - SUBAGENT_PROTOCOL.md: +~25 lines
  - HANDOFF_SCHEMA.md: +~15 lines
  - EXECUTION_PROTOCOL.md: net -~10 lines (Anti-XY shorter)
- All cross-references resolve (e.g., CLAUDE.md → EXECUTION_PROTOCOL §5 actually exists)

## Escalation Conditions
- If F3 CLAUDE.md slim removes information that no other file covers → halt, escalate (need to add it elsewhere first)
- If existing line numbering changes break references in untouched files → report

## Required Output (≤180 words)
1. F2: SYSTEM_INDEX line count delta, tier section names confirmed
2. F3: CLAUDE.md before/after line count, sections preserved (read-confirm, mode statement, completion, non-negotiables)
3. F4: SUBAGENT §11 added (yes/no), HANDOFF §thin-dispatch added (yes/no)
4. F5: EXECUTION §3 dedupe — line delta
5. Cross-reference check: confirm CLAUDE.md's references to EXECUTION_PROTOCOL §5, VALIDATION_PROTOCOL §11, MODE_DECISION_SCHEMA all resolve to actual sections
6. Any deviation
