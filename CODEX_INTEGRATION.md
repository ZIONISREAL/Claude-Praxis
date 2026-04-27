# CODEX_INTEGRATION.md

How Praxis composes with Codex.

## 1. Purpose

Claude-Praxis was originally written for Claude Code. Codex-Praxis is the compatibility layer that preserves the governance architecture while using Codex-native entrypoints and tools.

The protocols remain the same at the intent level:

- frame the real objective
- classify the execution mode
- write durable plans for non-trivial work
- use bounded handoffs for decomposed work
- validate against the intended outcome
- preserve state before context loss

## 2. Global Entrypoint

Codex reads `AGENTS.md`.

Install Codex-Praxis into:

```text
~/.codex/
```

The primary global entrypoint is:

```text
~/.codex/AGENTS.md
```

Do not require Codex users to create `~/.claude/`.

## 3. Project Workspace

For Codex-native projects, use:

```text
<repo>/.codex/
```

with the same structure defined in `PROJECT_STRUCTURE_SPEC.md`, translated as:

```text
<repo>/.claude/  ->  <repo>/.codex/
CLAUDE.md        ->  AGENTS.md
```

If a repository already contains `.claude/` from Claude-Praxis and the user has not requested migration, do not duplicate state just for ceremony. Continue with the existing workspace and record the compatibility decision in the plan.

## 4. Planning

Praxis plan-as-files remains canonical.

Codex's `update_plan` tool, when available, is tactical in-session state. It should mirror the current phase of the durable plan, not replace it.

| Concern | Durable Praxis plan | Codex `update_plan` |
|---|---|---|
| Scope | strategic, cross-session | current turn |
| Location | `<repo>/.codex/plans/active/` | conversation/tool state |
| Audience | future agent and user | current agent loop |
| Required | non-trivial tasks | useful for 2+ active steps |

## 5. Subagents

Use Codex subagent tools only when available and allowed by the current environment.

When subagents are used:

- write task packets under `<repo>/.codex/handoffs/outbox/`
- require results under `<repo>/.codex/handoffs/inbox/`
- give each subagent one bounded objective
- define allowed reads and writes
- integrate results into decisions, findings, risks, or validation records

If subagents are unavailable or restricted, decompose locally and record the reason in the active plan.

## 6. Skills, Plugins, MCP, and Browser Tools

Codex tools execute inside Praxis constraints.

Priority order:

1. system and developer instructions
2. direct user instructions
3. active Praxis plan and project rules
4. Praxis global protocols
5. skill or plugin instructions
6. default agent behavior

When a tool materially changes state, record the action in the project log for `standard`, `deep`, or `recovery` work.

## 7. Hooks and Reminders

Claude Code hook samples are not installed into Codex by default.

Codex-Praxis relies on:

- `AGENTS.md` as the load-bearing entrypoint
- durable project files for plans, memory, handoffs, and validation
- explicit validation records rather than hook enforcement

If Codex later exposes hook or automation primitives for the same lifecycle events, they may be added as optional advisory signals.

## 8. Installer Behavior

`install-codex.sh` installs protocol files into `~/.codex/`.

It must:

- preserve existing user files unless `--force` is passed
- create timestamped backups when overwriting
- record the source path for future updates
- provide `--check` for installed-file integrity

It must not:

- overwrite auth files
- overwrite `config.toml`
- install Claude-specific `settings.json` hooks
- mutate Codex SQLite state

## 9. When in Doubt

Keep the governance layer small and observable. Use Codex-native tools for execution, and use Praxis files for intent, planning, handoff, validation, and continuity.
