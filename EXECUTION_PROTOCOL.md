# EXECUTION_PROTOCOL.md

Mandatory execution behavior for the primary agent.

## 1. Core Principle

Optimize for actual task success, not superficial instruction compliance.

The agent must distinguish:

- what the user literally asked for
- what the user is actually trying to achieve
- what assumptions are being made
- what must be validated

## 2. Mandatory Pre-Execution Review

Before meaningful work, answer:

1. What is the real objective?
2. What did the user explicitly ask for?
3. Is there XY risk?
4. Is the requested path valid?
5. What assumptions exist?
6. What failure points exist?
7. Does this need plan-as-files?
8. Does this need subagents?
9. What validation is required?

## 3. Anti-XY Enforcement

See `CONSTITUTION.md` §3 (Anti-XY and Anti-GIGO Law) for the canonical rule. Operationally, the agent must:

1. Identify the literal request and the inferred true objective.
2. State any divergence to the user.
3. Proceed under the corrected framing if safe; otherwise support the literal request with explicit warning.

Do not optimize bad premises into polished wrong results.

## 4. Required Execution Order

1. Read `SYSTEM_INDEX.md`
2. Read required global docs
3. Read project `WORKSPACE_INDEX.md` if present
4. Read only project files listed there
5. Interpret true objective
6. Perform anti-XY review
7. Classify task complexity
8. Create/update plan if non-trivial
9. Decide whether subagents are required
10. Execute in bounded increments
11. Validate
12. Record decisions/findings/risks
13. Update index/plan/handoff as needed
14. Close or continue
15. Append all decision-class actions (mode classification, subagent dispatch, rule skip, closure claim) to `<repo>/.claude/logs/execution-log.md` with constitutional article tag per PROJECT_STRUCTURE_SPEC §11 article-tagging convention.

## 5. Execution Mode Selection

Refer to CLAUDE.md "Execution Mode Selection" for the canonical mode definitions: lightweight (trivial), standard, deep, recovery.

At task start, classify and announce: "Mode: [lightweight | standard | deep | recovery]".

Mode determines:

| Concern | lightweight | standard | deep | recovery |
|---|---|---|---|---|
| Plan-as-files | optional | required | required, v-bump on direction change | mandatory rebuild |
| Subagent dispatch | forbidden | as needed | required for multi-domain | as needed |
| Validation ladder | sanity only | full | full + objective verification doc | full + drift root-cause |
| Workspace creation | skip if absent | create if missing | create + populate context/ | repair existing |
| TodoWrite | optional | required for 2+ steps | required | required |

For standard, deep, and recovery modes, before the first non-trivial action the agent must write `<repo>/.claude/_meta/mode-decisions/<plan-id>.md` per `MODE_DECISION_SCHEMA.md`. Re-classifications during execution append to the same file.

Default to one tier higher when uncertain.

## 6. Plan-As-Files

Non-trivial work requires an active versioned plan in:

```text
<repo>/.claude/plans/active/
```

The plan must include:

- objective
- inferred objective
- scope
- non-goals
- assumptions
- risks
- steps
- validation path
- next action

## 7. Subagent Use

Use subagents when:

- investigation can be isolated
- multiple domains are involved
- large refactor is needed
- context pollution is likely
- validation can be separated
- comparison of alternatives is useful

Each subagent gets one bounded objective.

## 8. File-Based Handoff

Meaningful subagent results must be persisted to files.

Do not rely only on chat summaries.

## 9. Validation

After implementation:

1. minimal unit validation
2. callable-entry validation
3. realistic input validation if available
4. objective alignment validation

If no natural input exists, create a minimal hardcoded input where reasonable.

## 10. Failure Handling

On failure:

1. classify failure
2. update plan
3. record relevant findings/risks
4. propose next correct action

Do not stop with generic failure.

## 11. Compaction Discipline

Before compaction risk:

- update active plan
- update workspace index
- record next action
- record findings/risks
- append compact log

## 12. Completion Criteria

Complete only when:

- objective is correctly framed
- implementation exists
- validation evidence exists in `<repo>/.claude/validation/`
- output matches real objective
- durable files are updated
- in standard / deep / recovery: closure token (per VALIDATION_PROTOCOL §11) is included in the completion message AND in `validation/self-evaluation.md`

A completion message lacking a required closure token is a malformed close. The agent must produce evidence and re-issue.
