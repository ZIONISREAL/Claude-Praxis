# SELF_EVALUATION_PROTOCOL.md

Mandatory post-task self-audit for non-trivial work.

## 1. Principle

A task is not closed by claiming completion. The agent must inspect its own execution against constitution and protocols before declaring done.

Self-evaluation produces a record that future sessions and the user can audit.

## 2. When Required

Required after:
- standard mode tasks
- deep mode tasks
- recovery mode tasks

Skip for lightweight mode unless user requests it.

## 3. Output Location

```text
<project-workspace>/validation/self-evaluation.md
```

Append-mode. One entry per closed task.

## 4. Required Fields

```markdown
## <ISO-8601 UTC> — <plan-id or task name>

### Closure Token

[verbatim closure token from VALIDATION_PROTOCOL §11; required for standard / deep / recovery; "n/a — lightweight" otherwise]

### Objective Alignment
- Stated request: ...
- Inferred true objective: ...
- Were they the same? yes | no | partially
- If not: was the divergence flagged to user? yes | no

### Protocol Adherence
- Mode declared: ...
- Plan-as-files used: yes | no | n/a — reason if no
- Subagents used: count, with task ids
- Validation ladder reached level: 1-6 (per VALIDATION_PROTOCOL §2)
- Non-code validation applied: yes | no | n/a

### Skipped Rules

This section MUST be non-empty for standard, deep, and recovery mode tasks. A claim of zero skipped rules is treated as suspect by default — humans skip rules under real conditions; LLMs do too. Honest disclosure is preferred to false purity.

Format (one entry per skip):

- Rule: <constitutional article + short name, e.g. §X verification>, action: <skip | partial | deferred>, reason: <≤ 2 lines>, mitigation: <what compensates>

If you genuinely believe nothing was skipped, write a single entry stating so AND list any rule whose application was minimal/perfunctory. Pure compliance is the rare exception, not the default.

### Anti-XY Findings
- XY risk identified: yes | no
- If yes: original framing, corrected framing, user agreement

### Failure Modes Observed
- Errors: ...
- Tool failures: ...
- Drift incidents: ...
- Recovery actions: ...

### Improvement Notes
What would make the next similar task faster, safer, or more correct?
- ...

### Confidence
- Implementation: high | medium | low + reason
- Validation: high | medium | low + reason
- Objective fit: high | medium | low + reason
```

## 5. Honesty Requirement

The self-evaluation must record real failures and skips. A clean record with no skipped rules and no failure modes is suspicious — review whether the agent was actually disciplined or just self-flattering.

## 6. Integration with Metrics

Counts in self-evaluation feed into `~/.claude/metrics/` aggregations. See `metrics/README.md`.
