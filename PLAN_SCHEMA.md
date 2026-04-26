# PLAN_SCHEMA.md

Schema for versioned plan files.

## Location

Active plans:

```text
<repo>/.claude/plans/active/
```

Archived plans:

```text
<repo>/.claude/plans/archive/
```

## Naming

Use:

- `plan-v001.md`
- `plan-v002.md`

Do not use:

- `latest.md`
- `final.md`
- `final-final.md`

ID stability: the slug component must not change across versions. Only the `vNNN` suffix increments.

## Template

```md
# Plan v001

## Status

[active | superseded | completed | abandoned]

## Plan ID

[stable id, format: `plan-<slug>-v<NNN>` — e.g. `plan-auth-refactor-v001`]

## Created At

[ISO-8601 UTC, e.g. `2026-04-27T08:30:00Z`]

## Updated At

[ISO-8601 UTC, updated on every meaningful revision]

## Supersedes

[none | plan-v000.md]

## Objective

[task objective]

## Inferred True Objective

[real user/project goal]

## XY Risk Review

- Stated request:
- Possible proxy:
- True target:
- Chosen framing:

## Scope

### In Scope

- [item]

### Out of Scope

- [item]

## Assumptions

- [assumption]

## Risks

- [risk]

## Execution Phases

1. [phase]
2. [phase]
3. [phase]

## Subagent Plan

- [role/objective if needed]

## Validation Plan

- Minimal unit:
- Callable entry:
- Synthetic input:
- Realistic input:
- Objective verification:

## Current State

- Completed:
- In progress:
- Blocked:
- Remaining:

## Next Action

[next action]
```

## Update Rules

Create a new version when:

- objective changes
- scope changes
- assumptions fail
- major implementation path changes
- validation strategy changes
- subagent findings alter direction

Do not silently overwrite important plan history.
