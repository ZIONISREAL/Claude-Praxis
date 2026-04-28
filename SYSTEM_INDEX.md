# SYSTEM_INDEX.md

System-level routing index.

This file tells the agent which global system documents to read.
It is intentionally short.

Do not use this file for long explanations.

**【读取确认指令】读完此文档后，必须立即在回复开头汇报：「✅ 已读取 SYSTEM_INDEX.md，本次执行将载入：[Tier A / A+B / A+B+C ...]」**

## Path Variables

- `<runtime-home>`: the global agent runtime directory, e.g. `~/.claude/` or `~/.codex/`
- `<project-workspace>`: the project-local Praxis control plane, e.g. `<repo>/.claude/` or `<repo>/.codex/`
- `<workspace>`: whichever Praxis workspace `praxis doctor` is currently checking

Avoid root-style paths such as `/.claude/...`; they read as the filesystem root, not a project workspace.

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
- `VERIFICATION_PROTOCOL.md`
- `RULE_REGISTRY.md`

### Tier D — Add when first creating a project workspace

- `PROJECT_STRUCTURE_SPEC.md`
- `INTEGRATION.md`

### Tier E — Add when context compaction is imminent

- `COMPACT_PROTOCOL.md`

## Project-Level Next Step

After reading required global files, inspect:

- `<project-workspace>/WORKSPACE_INDEX.md`

If it does not exist and the task is non-trivial, create the project-local workspace (`.claude/` for Claude Code, `.codex/` for Codex) according to `PROJECT_STRUCTURE_SPEC.md` and `CODEX_INTEGRATION.md`.

## Rule

Read only what is needed for the current execution mode.
Do not blindly load all global documents.

When a task names a specific verification problem, prefer rule/section routing over whole-file reading:

```yaml
READ_RULES:
  - praxis.closure.evidence-sha256-matches
  - praxis.handoff.packet-exists
READ_SECTIONS:
  - VALIDATION_PROTOCOL.md §11
  - VERIFICATION_PROTOCOL.md §4
```

If a rule ID is enough to execute safely, load `rules.json` and the named protocol section before reading the entire protocol file.
