# INTEGRATION.md

How this harness composes with Claude Code's native features.

## 1. Purpose

This file resolves the ambiguity of "do I use the harness concept or the native tool". The harness (CONSTITUTION + protocols) and Claude Code (TodoWrite, Agent tool, Skills, MCP, hooks) overlap. This document fixes precedence and mapping so the agent does not duplicate work or skip required structure.

## 2. Active Plan vs TodoWrite

| Concern | Active Plan File | TodoWrite |
|--------|------------------|-----------|
| Layer | strategic, cross-session | tactical, in-session |
| Persistence | durable file in `.claude/plans/active/` | ephemeral conversation state |
| Audience | future agent + future user | current execution loop |
| When to use | non-trivial work spanning > 1 session OR > 30 min | granular step tracking inside one session |

Rule: Non-trivial work creates BOTH. Active plan = the strategic objective and phases. TodoWrite = today's execution checklist derived from the current phase.

## 3. Subagent Dispatch — Native Agent tool

Use Claude Code's Agent tool with `subagent_type` parameter.

| Harness Role | subagent_type |
|------|------|
| investigator | Explore (or general-purpose) |
| implementer | general-purpose |
| verifier | general-purpose with review prompt |
| critic / reviewer | code-reviewer |
| architect / planner | Plan |

Each Agent invocation must include the HANDOFF_SCHEMA Task Packet content embedded in the prompt — even if the actual handoff file is not written, the structure ensures bounded scope.

For repository-wide research with no specific entry point: use `Explore` subagent with thoroughness level.

For parallel-independent tasks: dispatch multiple Agent calls in a single message.

## 4. Skills System

Skills (invoked via the `Skill` tool) are pre-defined behaviors. Priority order:

1. Direct user instructions (highest)
2. Active plan + project-local rules
3. This harness (CONSTITUTION + protocols)
4. Skills
5. Default Claude Code system behavior (lowest)

When a Skill applies AND a harness protocol applies, the harness wins on principle. The Skill executes within harness constraints (e.g., a brainstorming skill still produces output that flows into the active plan).

If a Skill produces a deliverable (report, plan, document), that output must land in `.claude/` — not float in the conversation.

## 5. MCP Tools

When MCP tool calls are part of non-trivial task execution, log invocations to `.claude/logs/execution-log.md` with: tool name, parameters summary, outcome.

Authentication or connector setup actions go to `.claude/memory/decisions.md` so future sessions know what's already configured.

## 6. superpowers Plugin (if installed)

If `superpowers:writing-plans`, `superpowers:executing-plans`, or `superpowers:brainstorming` skills are available:

- Prefer them as the procedural HOW for plan creation / brainstorming
- The output location remains `.claude/plans/active/` per PLAN_SCHEMA
- The plan content remains conformant with PLAN_SCHEMA fields

The harness defines the WHAT and WHERE; superpowers may handle the HOW.

## 7. Hooks (~/.claude/settings.json)

Hooks are the enforcement layer. They convert advisory protocol rules into observable signals.

Currently hook-enforced:
- SessionStart: visible harness load confirmation
- UserPromptSubmit: detect non-trivial keywords, inject reminder
- PreCompact: write timestamp marker, prompt durable-state dump

Hooks are advisory — they never block tool execution. See `settings.json` for current configuration.

## 8. TodoWrite Inside Lightweight Mode

In lightweight mode, TodoWrite is OPTIONAL. Use it only if the trivial task has 3+ steps.

In standard or deep mode, TodoWrite is REQUIRED for any phase that has 2+ ordered steps.

## 9. When in Doubt

If a native feature does the job, prefer it. The harness exists to fill the gaps Claude Code doesn't fill (durable cross-session memory, file-based subagent handoff, structured plan versioning, anti-XY enforcement).

Do not duplicate native features. Do not skip harness rules where Claude Code is silent.
