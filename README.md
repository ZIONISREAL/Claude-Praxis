# Claude-Praxis

> **The most systematic harness system for Claude Code.**

A constitutional, file-based execution framework for Claude Code that turns ad-hoc agent runs into auditable, recoverable, multi-session work.

The name comes from Greek **praxis** (πρᾶξις) — disciplined practice, the unity of theory and action. Code written is not the same as task done; this harness enforces that distinction.

## Why

Claude Code is powerful but stateless across sessions, optimistic about completion, and easily derailed by mis-framed user requests. This harness adds:

- **Anti-XY enforcement** — detect when the user asked for the wrong thing
- **Plan-as-files** — durable strategic memory that survives context compaction
- **Subagent contracts** — file-based handoff with bounded scope
- **Validation discipline** — completion requires evidence, not confidence
- **Mode classification** — quantitative trivial vs non-trivial gates so the system stays out of the way for simple tasks
- **Hook-level enforcement** — advisory hooks make protocol adherence visible

## Layered Architecture

```
Identity (CONSTITUTION)
  ↓
Behavior  (EXECUTION / SUBAGENT / VALIDATION / COMPACT / SELF_EVALUATION)
  ↓
Schema    (HANDOFF / PLAN)
  ↓
Routing   (SYSTEM_INDEX / WORKSPACE_INDEX)
  ↓
Substrate (PROJECT_STRUCTURE_SPEC)
  ↓
Integration (INTEGRATION / settings.json hooks)
  ↓
Lifecycle (MIGRATION / install.sh / VERSION)
```

## Install

```bash
git clone <repo> ~/claude-harness
cd ~/claude-harness
./install.sh --from .
```

Or upgrade existing:

```bash
./install.sh --from . --check
./install.sh --from .          # additive, preserves your files
```

See `install.sh --help`.

## Quickstart

After install, in any project:

1. Open Claude Code in the project directory
2. Claude reads `~/.claude/CLAUDE.md` automatically (global memory)
3. For non-trivial tasks, Claude creates `<project>/.claude/` per `PROJECT_STRUCTURE_SPEC.md`
4. Active plan lives at `<project>/.claude/plans/active/plan-v001.md`
5. Validation evidence accumulates under `<project>/.claude/validation/`

## File Map

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global entrypoint + execution mode rules |
| `SYSTEM_INDEX.md` | Routing index — which docs to read for current task |
| `CONSTITUTION.md` | High-order behavioral law |
| `INTEGRATION.md` | Bridge to native Claude Code features |
| `EXECUTION_PROTOCOL.md` | Mandatory execution behavior |
| `SUBAGENT_PROTOCOL.md` | Subagent dispatch rules |
| `VALIDATION_PROTOCOL.md` | Completion evidence ladder |
| `COMPACT_PROTOCOL.md` | Context compaction continuity |
| `SELF_EVALUATION_PROTOCOL.md` | Post-task self-audit |
| `HANDOFF_SCHEMA.md` | Subagent task packet + result schemas |
| `PLAN_SCHEMA.md` | Versioned plan schema |
| `PROJECT_STRUCTURE_SPEC.md` | Project-level `.claude/` workspace spec |
| `PROJECT_WORKSPACE_INDEX_TEMPLATE.md` | Template for project WORKSPACE_INDEX |
| `MIGRATION_PROTOCOL.md` | Cross-version evolution rules |
| `metrics/` | Cross-session aggregations |
| `settings.json` | Hook configuration (advisory enforcement) |
| `install.sh` | Idempotent installer |

## Execution Modes

| Mode | When | Overhead |
|------|------|----------|
| lightweight | trivial: <=2 files, <=8 tool calls, single domain | minimal |
| standard | default for non-trivial | full protocol |
| deep | refactors, migrations, architecture, >30 calls | full + risk file |
| recovery | drift detected | rebuild plan |

## Design Principles

1. Files are canonical, conversation is ephemeral
2. Protocol fills gaps, not duplicates native features
3. Hooks make adherence observable
4. Lightweight mode keeps the system out of the way for simple tasks
5. Honest self-evaluation over self-flattering completion claims

## License

MIT (recommended; user to confirm before publishing).

## Status

Version 1.0.0 — see `VERSION` and `CHANGELOG.md`.
