# HANDOFF_SCHEMA.md

Schemas for file-based agent handoff.

## 1. Subagent Task Packet

Location:

```text
<repo>/.claude/handoffs/outbox/
```

Template:

```md
# Subagent Task Packet

## Task ID

[unique id]

## Parent Plan

[path to active plan]

## Role

[investigator | implementer | verifier | critic | summarizer]

## Model

sonnet

## Effort

medium

## Objective

[one bounded objective]

## Scope

### In Scope

- [item]

### Out of Scope

- [item]

## Required Inputs

- [file/path/context]

## Allowed Reads

- [file/path]

## Allowed Writes

- [file/path]

## Constraints

- [constraint]

## Required Output

- [artifact]

## Done Criteria

- [criterion]

## Escalation Conditions

Stop and report if:

- [condition]
```

## 2. Subagent Result

Location:

```text
<repo>/.claude/handoffs/inbox/
```

Template:

```md
# Subagent Result

## Task ID

[matching id]

## Parent Plan

[path]

## Status

[complete | partial | blocked]

## Summary

[short summary]

## Files Inspected

- [file]

## Files Changed

- [file or none]

## Findings

- [finding]

## Assumptions

- [assumption]

## Risks

- [risk]

## Rejected Paths

- [path and reason]

## Validation Performed

- [validation]

## Recommended Next Action

[next action]
```

## 3. Shared Artifact

Location:

```text
<repo>/.claude/handoffs/shared/
```

Use for:

- shared schemas
- shared interface contracts
- cross-agent notes
- stable reference context

Do not use shared artifacts as dumping grounds.
