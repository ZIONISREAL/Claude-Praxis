# SUBAGENT_PROTOCOL.md

Rules for using subagents.

## 1. Purpose

Subagents exist to perform bounded, isolated, single-purpose work.

They are used to reduce context pollution, increase specialization, and improve auditability.

## 2. When Required

Use subagents when work involves:

- multiple independent subproblems
- separate research and implementation phases
- separate implementation and validation phases
- large refactors
- architecture alternatives
- risk review
- isolated test generation
- multi-module analysis

## 3. One Subagent, One Objective

Each subagent must receive exactly one coherent task.

Good:

- inspect API schema mismatch
- validate parser edge cases
- audit migration risk
- summarize auth flow

Bad:

- fix backend
- improve everything
- investigate and implement and test all at once

## 4. Main Agent Responsibilities

The main agent must:

1. create scoped handoff task packet
2. define inputs
3. define forbidden actions
4. define output location
5. define done criteria
6. integrate subagent output
7. decide what becomes canonical memory

## 5. Subagent Responsibilities

Subagent must:

- follow assigned scope
- avoid unrelated exploration
- write results to required handoff artifact
- separate findings from assumptions
- surface risks
- avoid claiming more certainty than evidence supports

## 6. File-Based Handoff

Use:

```text
<repo>/.claude/handoffs/outbox/
```

for task packets.

Use:

```text
<repo>/.claude/handoffs/inbox/
```

for subagent results.

Use:

```text
<repo>/.claude/handoffs/shared/
```

for shared cross-agent references.

## 7. Search Scope Contract

The MAIN AGENT is responsible for bounding subagent reads via the task packet, not the subagent itself. Each task packet must specify ONE of:

- Explicit `Allowed Reads` list of files/paths, OR
- A `Search Scope Hint` directive: domain, directory glob, or "repository-wide research" with justification

The subagent then:

- Treats `Allowed Reads` as a hard limit when provided
- Treats `Search Scope Hint` as a soft default; may expand if scope hint is "repository-wide" or if expansion is justified by a finding
- Records any expansion in its result file under `Files Inspected`

This replaces the unenforceable rule "subagents must not scan the entire repository". Repository-wide scans are legitimate when the main agent authorizes them (e.g., for `Explore` subagent_type).

## 8. Write Boundaries

Subagents may write:

- assigned handoff result
- assigned scratch output
- explicitly permitted project files

Subagents should not directly modify:

- project constitution
- workspace index
- active plan
- core memory files

unless explicitly authorized.

## 9. Integration

Main agent must review subagent outputs and decide whether to promote content into:

- decisions
- findings
- assumptions
- risks
- rejected paths
- validation records

## 10. Model and Effort Constraints

Every subagent dispatch must be configured with:

- **Model**: `sonnet` (resolves to the current Sonnet 4.6 in this environment)
- **Effort**: `medium` (no extended thinking, no minimal mode)

Rationale: Sonnet 4.6 has the strongest protocol-adherence-per-token among available models. Medium effort prevents both over-thinking on routine tasks (cost) and under-thinking on substantive work (quality). Opus is reserved for the main agent's orchestration and final audits; Haiku is forbidden for non-trivial subagent work due to weaker protocol adherence.

### Enforcement

Native `Agent` tool: pass `model: "sonnet"` on every invocation.

Effort has no native parameter. The main agent MUST embed this directive verbatim in the subagent prompt:

```
Effort: medium. Do not invoke extended thinking. Do not skip reasoning. Match depth to task scope.
```

### Override

The main agent may override only when:

- The task is a final critical audit (Opus allowed)
- The task is genuinely trivial classification or formatting (Haiku allowed, with justification logged)

Each override must be recorded in `.claude/logs/subagent-log.md` with the `model` and `effort` chosen and the reason.

## 11. Thin-Dispatch Requirement

For any subagent task whose specification exceeds 1000 characters, the main agent MUST:

1. Write the full task packet (per `HANDOFF_SCHEMA.md` §1) as a file at `<repo>/.claude/handoffs/outbox/<task-id>.md` (or `~/.claude/_meta/handoffs/outbox/<task-id>.md` for harness-meta work).

2. Dispatch with a thin prompt of ≤ 300 tokens, structured as:

```
Effort: medium. Do not invoke extended thinking.
Task packet: <absolute path to packet file>
Read the packet, execute per its Specification section, report per its Required Output section.
```

For tasks with specifications ≤ 1000 characters, inline dispatch is permitted.

### Why This Rule Exists

Inlining a 5K-token specification into the Agent tool prompt copies that text into the main agent's running transcript, charging every subsequent conversation message for re-reading it. Writing the packet as a file shifts the cost to a one-time read by the subagent, keeps the main transcript lean, and produces an auditable handoff record per CONSTITUTION §V (durable state).

### Verification

A dispatch is non-compliant if the prompt exceeds 300 tokens AND the spec exceeds 1000 characters. Audit subagents and self-evaluation should flag this.
