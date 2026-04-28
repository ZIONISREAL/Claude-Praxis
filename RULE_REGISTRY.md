# RULE_REGISTRY.md

Human-readable projection of the Praxis verification rules. The canonical machine-readable source is `rules.json`; `praxis doctor` loads rule metadata from that file and attaches local check functions by rule ID.

## Stability Commitment

Rule IDs with `"stability": "stable"` in `rules.json` are **public API**. Renaming or removing a stable rule ID requires a MAJOR version bump per `MIGRATION_PROTOCOL.md`.

Rule IDs with `"stability": "provisional"` may be renamed or removed in any minor version. Promote a provisional rule to stable when:
- It has been in the registry for at least one MINOR release
- Its check function is implemented (not "manual")
- No semantic ambiguity has been reported

## ID Naming Convention

```
praxis.<area>.<rule>
```

- `<area>` is one of: closure, mode, plan, handoff, eval, log, dispatch
- `<rule>` is a hyphen-separated short noun phrase
- Lowercase ASCII only; no underscores; no version suffixes

## Severity Levels

- `error` — `doctor check` exits 1 if this rule FAILs
- `warning` — surfaced in output but never causes non-zero exit
- `info` — purely informational; often "manual review only"

## Stable Rules

### `praxis.closure.token-format`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** A closure token in a completion claim must match the format `[CLOSURE: plan=<id> evidence=<path> last-line="<text>" at=<iso8601>]` with all four fields non-empty.
- **Constitutional reference:** §9 (Verification Before Completion); VALIDATION_PROTOCOL §11.
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor verify-closure <plan-id>`

### `praxis.closure.evidence-exists`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** The path in the token's `evidence` field must point to an existing file relative to the workspace root.
- **Constitutional reference:** §5 (Durable State Over Ephemeral Context); VALIDATION_PROTOCOL §11.
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor verify-closure <plan-id>`

### `praxis.closure.last-line-matches`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** The token's `last-line` value must equal the actual last non-empty line of the referenced evidence file (verbatim, after stripping trailing whitespace). This rule is what makes the closure token cryptographically meaningful.
- **Constitutional reference:** §9; VALIDATION_PROTOCOL §11.
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor verify-closure <plan-id>`

### `praxis.closure.timestamp-parseable`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** The token's `at` field must parse as ISO-8601 UTC.
- **Constitutional reference:** VALIDATION_PROTOCOL §11.
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor verify-closure <plan-id>`

### `praxis.mode.rubric-exists`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** Non-lightweight modes must produce a mode-decision rubric file at `<workspace>/_meta/mode-decisions/<plan-id>.md` per `MODE_DECISION_SCHEMA.md`.
- **Constitutional reference:** §5; CLAUDE.md "Mode Classification".
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor check`

### `praxis.plan.exists`

- **Severity:** error
- **Applies to:** standard, deep, recovery
- **Description:** Non-lightweight tasks must have an active plan file `plan-vNNN.md` in `<workspace>/plans/active/` (or `_meta/` for harness-meta workspaces).
- **Constitutional reference:** §7 (Plan-As-Files Law).
- **Check status:** implemented (Tier 1)
- **Doctor command:** `praxis doctor check`

## Provisional Rules

### `praxis.closure.evidence-sha256-matches`

- **Severity:** warning
- **Applies to:** standard, deep, recovery
- **Description:** When a closure token includes `sha256`, the digest must match the referenced evidence file. Missing `sha256` is treated as legacy last-line-only binding and reported as a warning.
- **Constitutional reference:** §9; VALIDATION_PROTOCOL §11.
- **Check status:** implemented (Tier 2)
- **Doctor command:** `praxis doctor verify-closure <plan-id>`

### `praxis.eval.skipped-non-empty`

- **Severity:** warning
- **Applies to:** standard, deep, recovery
- **Description:** SELF_EVALUATION's "Skipped Rules" section must have at least one entry. False purity (claiming zero skipped rules) is suspect by default per SELF_EVALUATION_PROTOCOL.
- **Constitutional reference:** SELF_EVALUATION_PROTOCOL §5.
- **Check status:** basic (Tier 2)
- **Doctor command:** `praxis doctor check`

### `praxis.log.article-tagged`

- **Severity:** warning
- **Applies to:** standard, deep, recovery
- **Description:** Decision-class actions in `execution-log.md` must carry a constitutional-article tag in `[§N rule-name]` format.
- **Constitutional reference:** PROJECT_STRUCTURE_SPEC §11.
- **Check status:** basic (Tier 2)
- **Doctor command:** `praxis doctor check`

### `praxis.handoff.packet-exists`

- **Severity:** mode-aware (warning by default; error for agentic/deep/recovery dispatches)
- **Applies to:** standard, deep, recovery
- **Description:** Each subagent dispatch in `execution-log.md` should have a corresponding packet file in `handoffs/outbox/<task-id>.md`.
- **Constitutional reference:** SUBAGENT_PROTOCOL §11; HANDOFF_SCHEMA §1.
- **Check status:** basic (Tier 2)
- **Doctor command:** `praxis doctor check`

### `praxis.handoff.thin-dispatch`

- **Severity:** warning
- **Applies to:** standard, deep
- **Description:** Static approximation that packet-backed dispatches with packet files exceeding 1000 characters should use thin-dispatch prompts of ≤300 tokens and include a `Task packet:` marker in the logged dispatch target.
- **Constitutional reference:** SUBAGENT_PROTOCOL §11.
- **Check status:** basic (Tier 2)
- **Doctor command:** `praxis doctor check`

### `praxis.plan.id-stable`

- **Severity:** info
- **Applies to:** any plan
- **Description:** A plan's slug component must remain stable across versions. Only the `vNNN` suffix may change. Cross-version comparison required; manual review in v1.5.
- **Constitutional reference:** PLAN_SCHEMA "Naming"; CONSTITUTION §12 (Naming Stability).
- **Check status:** manual (Tier 3)
- **Doctor command:** `praxis doctor lint` (info only)

## How To Add a New Rule

1. Add the rule metadata to `rules.json` with `"stability": "provisional"`.
2. Implement the check in the `praxis` CLI and map it by rule ID.
3. Reference the rule from at least one existing protocol where it applies.
4. Regenerate or update this human-readable projection.
5. After one MINOR release, propose promotion to `"stability": "stable"`.

## Versioning

This registry's compatibility tracks the harness MAJOR version. v1.x is stable for stable rules. v2.0 may break stable rule IDs.
