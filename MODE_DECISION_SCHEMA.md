# MODE_DECISION_SCHEMA.md

Schema for the structural artifact produced when an agent classifies execution mode for non-trivial work.

## Purpose

Mode classification is the entry gate to the protocol stack. LLMs systematically under-classify (bias toward lightweight to avoid overhead). This schema converts the classification from a self-asserted label into an auditable file the user, a future agent, and audit subagents can review.

## Location

```text
<project-workspace>/_meta/mode-decisions/<plan-id>.md
```

One file per plan. Created at task start, before any execution.

## Required for

- standard mode (mandatory)
- deep mode (mandatory)
- recovery mode (mandatory)

Not required for:
- lightweight mode (zero-friction principle)

## Template

```md
# Mode Decision — <plan-id>

## Created At

[ISO-8601 UTC]

## Stated Request

[verbatim or near-verbatim user request]

## Inferred True Objective

[the actual goal as the agent reads it]

## Rubric

| Criterion | Estimate | Trivial-bound | Trivial? |
|---|---|---|---|
| Files to modify | <N> | ≤ 2 | yes / no |
| Tool calls expected | <N> | ≤ 8 | yes / no |
| Domains touched | <N> | 1 | yes / no |
| Touches production paths (src/, prod/, deploy/, migrations) | yes / no | no | yes / no |
| Multi-phase | yes / no | no | yes / no |
| Subagent dispatch needed | yes / no | no | yes / no |
| New architecture decision | yes / no | no | yes / no |
| Durable state needed beyond conversation | yes / no | no | yes / no |

## All Trivial Columns Are "yes"?

[yes | no]

## Risk Indicators

- [any risk signals: ambiguity, breaking change, prod path, security surface, data migration, etc.]

## Selected Mode

[lightweight | standard | deep | recovery]

## Justification

[2-4 lines. If selected mode disagrees with rubric (e.g., rubric says trivial but selected standard), state why.]

## Re-Classification Triggers

If during execution any of the following occurs, the agent must update this file with a new entry under "Re-classifications" and announce the new mode:

- Files modified exceeds estimate by 50%
- Tool calls exceed estimate by 100%
- A previously-unforeseen domain appears
- A previously-unforeseen risk indicator surfaces

## Re-classifications

(append on each event)

- [ISO-8601 UTC] [old mode → new mode] [reason, ≤ 1 line]
```

## Update Rules

- Created once at task start
- Re-classifications are append-only — never delete prior entries
- On task close, the file is referenced by `validation/closure-<plan-id>.md`
