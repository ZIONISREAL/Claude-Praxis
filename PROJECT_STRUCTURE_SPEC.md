# PROJECT_STRUCTURE_SPEC.md

Defines the mandatory project-level `.claude/` workspace.

## 1. Core Principle

Every serious project must contain a project-local `.claude/` workspace.

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
<repo>/.claude/
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
└── logs/
    ├── execution-log.md
    └── compact-log.md
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
- `action`: read | write | edit | dispatch-subagent | run-tool | decide | reject | recover
- `target`: file path, tool name, or subagent task id
- `outcome`: ok | partial | fail | escalated

Section headers `## YYYY-MM-DD` may group entries by day.

Do not log trivial reads in lightweight mode.
Do log every Edit/Write/Bash in standard or deep mode.

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

## 12. Creation Rules

Create project-local `.claude/` when:

- task is multi-step
- task may exceed short context
- subagents are needed
- validation is non-trivial
- refactor or architecture work is involved
- XY risk exists
- running under broad permissions

## 13. Repair Rules

If incomplete:

- create missing directories
- create missing files
- preserve existing valid content
- do not overwrite user-authored files silently
- record repair in `logs/execution-log.md`

## 14. Forbidden Patterns

Forbidden:

- all state only in chat
- vague subagent delegation
- completion without validation
- repeated failed paths due to missing memory
- solving literal request while ignoring real objective
- turning `.claude/` into unstructured notes
