# PROJECT_STRUCTURE_SPEC.md

Defines the mandatory project-level Praxis workspace.

## 0. Path Variables

- `<repo>`: the repository or project root.
- `<project-workspace>`: the project-local Praxis control plane. For Claude Code this is `<repo>/.claude/`; for Codex this is `<repo>/.codex/`.
- `<runtime-home>`: the global runtime installation, such as `~/.claude/` or `~/.codex/`.

Do not write root-style paths such as `/.claude/...`; they imply the filesystem root. Use `<project-workspace>/...` when describing project-local state.

## 1. Core Principle

Every serious project must contain a project-local Praxis workspace.

This workspace is the execution substrate for:

- task decomposition
- plan-as-files orchestration
- subagent coordination
- validation evidence
- context persistence
- anti-XY correction
- structured handoff
- decision memory
- execution traceability

## 2. Mandatory Project Structure

```text
<project-workspace>/
├── WORKSPACE_INDEX.md
├── CLAUDE.md
├── constitution/
│   ├── project-constitution.md
│   ├── execution-rules.md
│   └── quality-gates.md
├── context/
│   ├── project-context.md
│   ├── architecture-context.md
│   ├── constraints.md
│   ├── glossary.md
│   └── objective-model.md
├── plans/
│   ├── active/
│   ├── archive/
│   └── templates/
├── memory/
│   ├── decisions.md
│   ├── findings.md
│   ├── assumptions.md
│   ├── risks.md
│   └── rejected-paths.md
├── handoffs/
│   ├── inbox/
│   ├── outbox/
│   └── shared/
├── validation/
│   ├── test-strategy.md
│   ├── test-results.md
│   ├── acceptance-checklist.md
│   └── objective-verification.md
├── logs/
│   ├── execution-log.md
│   └── compact-log.md
└── _meta/
    └── mode-decisions/
```

## 3. `WORKSPACE_INDEX.md`

Purpose:

- thin routing index
- tells the agent which project files to read now
- prevents token waste
- identifies current authoritative files

Must be short.

Must contain:

- current objective
- authoritative files
- active read set
- current active plan
- next action

Must not contain:

- long summaries
- historical plan lists
- raw subagent output
- large project explanations

## 4. `.claude/CLAUDE.md`

Purpose:

- project-local entrypoint
- repository-specific operational reminder
- pointer to local rules and index

Must contain:

- local read order
- special local cautions
- active workspace index pointer

## 5. `constitution/`

Local project law.

### `project-constitution.md`

Contains:

- repository mission
- local invariants
- forbidden actions
- risk boundaries
- validation expectations

### `execution-rules.md`

Contains:

- concrete repo workflow
- safe mutation zones
- build/test commands
- local footguns

### `quality-gates.md`

Contains:

- definition of done
- minimum checks
- required validation evidence

## 6. `context/`

Durable project understanding.

### `project-context.md`

Contains project purpose, workflows, components, and current priorities.

### `architecture-context.md`

Contains modules, boundaries, data flow, entrypoints, integration surfaces, and coupling risks.

### `constraints.md`

Contains technical, runtime, deployment, compatibility, performance, and user constraints.

### `glossary.md`

Contains domain terms and naming conventions.

### `objective-model.md`

Anti-XY anchor file.

Contains:

- stated request
- inferred objective
- success signal
- rejected interpretations
- unresolved ambiguity
- chosen path and why

Required when the task has ambiguity or XY risk.

## 7. `plans/`

### `plans/active/`

Holds active versioned plans.

Use:

- `plan-v001.md`
- `plan-v002.md`

Exactly one plan should be considered current unless explicitly split.

### `plans/archive/`

Holds superseded, completed, or abandoned plans.

### `plans/templates/`

Optional local templates.

## 8. `memory/`

Durable knowledge.

### `decisions.md`

Records decisions, reasons, alternatives, and implications.

### `findings.md`

Tacit-knowledge reservoir.

Captures:

- non-obvious discoveries
- hidden coupling
- runtime quirks
- tool limitations
- what worked
- what looked right but failed

### `assumptions.md`

Tracks assumptions, confidence, verification method, and invalidation trigger.

### `risks.md`

Tracks risks, severity, affected area, mitigation, and status.

### `rejected-paths.md`

Prevents repeated failed approaches after compaction.

Records:

- attempted path
- why rejected
- invalidating signal
- whether permanently invalid or temporarily unsuitable

## 9. `handoffs/`

File-based agent communication.

### `inbox/`

Incoming results from subagents.

### `outbox/`

Main-agent-issued task packets for subagents.

### `shared/`

Shared references, schemas, assumptions, and interface contracts.

## 10. `validation/`

Proof that work matches objective.

### `test-strategy.md`

Defines smallest unit test, callable entry condition, real/synthetic input path, integration path, and failure criteria.

### `test-results.md`

Records commands, inputs, outputs, pass/fail, anomalies, and uncertainty.

### `acceptance-checklist.md`

Tracks implementation, tests, output contract, regression risk, and objective alignment.

### `objective-verification.md`

Final anti-XY closure.

Answers:

- did we build what was requested?
- did we solve the actual problem?
- are those the same?
- what gap remains?

## 11. `logs/`

Structured operational trace. Append-only.

### `execution-log.md`

One entry per meaningful action. Format (tab-separated):

```text
<ISO-8601 UTC>  <mode>  <phase>  <action>  <target>  <outcome>
```

Where:
- `mode`: lightweight | standard | deep | recovery
- `phase`: scan | plan | execute | validate | handoff | compact
- `action`: read | write | edit | dispatch-subagent | run-tool | decide | reject | recover | skip-rule | classify-mode | claim-closure
- `target`: file path, tool name, or subagent task id
- `outcome`: ok | partial | fail | escalated

Section headers `## YYYY-MM-DD` may group entries by day.

Do not log trivial reads in lightweight mode.
Do log every Edit/Write/Bash in standard or deep mode.

### Article Tagging Convention

Every entry whose action is one of {decide, reject, dispatch-subagent, skip-rule, classify-mode, claim-closure} MUST carry a constitutional-article tag at the start of the `target` field, in the form `[§N rule-name]`. Examples:

```text
2026-04-27T08:00:00Z  standard  plan      classify-mode      [§II goal-truth] mode=standard rubric=_meta/mode-decisions/plan-foo-v001.md  ok
2026-04-27T08:15:00Z  standard  execute   dispatch-subagent  [§VIII subagent-law] sa-investigator-1 scope=auth-flow                       ok
2026-04-27T09:00:00Z  standard  validate  skip-rule          [§X verification] skipped realistic-input — no real input available; sanity+synthetic only  partial
2026-04-27T09:15:00Z  standard  validate  claim-closure      [§X verification] [CLOSURE: plan=plan-foo-v001 evidence=...]                ok
```

The article reference must correspond to the actual constitutional article governing the action. A grep across `execution-log.md` for `\[§N` reveals which articles were touched; absence of any tag for §X over a closing task is a detectable adherence gap.

### Discipline

This convention is OBSERVABILITY, not enforcement. The agent is not asked to obey better; it is asked to leave a trace. Missing or incorrect tags surface in self-evaluation and audit, not in flight.

### `compact-log.md`

One entry per compaction event. Format:

```markdown
## <ISO-8601 UTC>

- objective: ...
- active plan: <path>
- phase: ...
- completed: ...
- unfinished: ...
- next action: ...
- triggered by: <auto | manual | hook>
```

### `subagent-log.md` (optional)

If subagents are dispatched, one entry per dispatch:

```markdown
## <ISO-8601 UTC> <task-id>

- subagent_type: ...
- objective: ...
- duration_ms: ...
- status: complete | partial | blocked
- artifacts: <files written>
- escalations: ...
```

## 12. `_meta/`

Project-local meta-workspace for execution-control artifacts.

### `_meta/mode-decisions/`

One file per plan, named `<plan-id>.md`, conforming to `MODE_DECISION_SCHEMA.md`.

### `_meta/last_compact_marker.txt`

Optional. Written by the PreCompact hook (see settings.json.sample). Contains the timestamp of the most recent compaction.

## 13. Creation Rules

Create project-local `.claude/` when:

- task is multi-step
- task may exceed short context
- subagents are needed
- validation is non-trivial
- refactor or architecture work is involved
- XY risk exists
- running under broad permissions

## 14. Repair Rules

If incomplete:

- create missing directories
- create missing files
- preserve existing valid content
- do not overwrite user-authored files silently
- record repair in `logs/execution-log.md`

## 15. Forbidden Patterns

Forbidden:

- all state only in chat
- vague subagent delegation
- completion without validation
- repeated failed paths due to missing memory
- solving literal request while ignoring real objective
- turning `.claude/` into unstructured notes
