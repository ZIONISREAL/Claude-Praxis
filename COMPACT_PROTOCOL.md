# COMPACT_PROTOCOL.md

Rules for preserving continuity across context compaction.

## 1. Principle

Context compaction must not destroy operational continuity.

Critical state must be file-backed before compaction.

## 2. Before Compaction

Ensure the following are current:

- `WORKSPACE_INDEX.md`
- active plan
- objective model
- decisions
- findings
- assumptions
- risks
- rejected paths
- validation status
- compact log

## 3. Required Compact Summary

Append to:

```text
<project-workspace>/logs/compact-log.md
```

Include:

- current objective
- active plan
- current phase
- completed work
- unfinished work
- latest decisions
- latest findings
- latest risks
- blockers
- next action

## 4. After Compaction

Rehydrate from:

1. `.claude/WORKSPACE_INDEX.md`
2. active plan listed there
3. `context/objective-model.md`
4. `memory/decisions.md`
5. `memory/findings.md`
6. `memory/rejected-paths.md`
7. `validation/objective-verification.md`
8. `logs/compact-log.md`

## 5. Compact Timing

Prefer compact at clean phase boundaries:

- after investigation
- after plan revision
- after subagent integration
- after validation record
- before starting a new phase

## 6. Forbidden

Do not compact while important state exists only in chat.
