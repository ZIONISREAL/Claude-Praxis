# SYSTEM_INDEX.md

System-level routing index.

This file tells the agent which global system documents to read.
It is intentionally short.

Do not use this file for long explanations.

**【读取确认指令】读完此文档后，必须立即在回复开头汇报：「✅ 已读取 SYSTEM_INDEX.md，本次执行将载入：[列出实际选择的文档]」**

## Default Read Set

For ordinary non-trivial tasks, read:

- `CONSTITUTION.md`
- `INTEGRATION.md`
- `EXECUTION_PROTOCOL.md`
- `PROJECT_STRUCTURE_SPEC.md`
- `PLAN_SCHEMA.md`
- `MODE_DECISION_SCHEMA.md`
- `VALIDATION_PROTOCOL.md`

## If the task involves subagents, also read

- `SUBAGENT_PROTOCOL.md`
- `HANDOFF_SCHEMA.md`

## If the task is long-running or may compact context, also read

- `COMPACT_PROTOCOL.md`

## If the repository lacks project-local `.claude/`, also read

- `PROJECT_STRUCTURE_SPEC.md`

## If the task is non-trivial and standard/deep mode, also read

- `SELF_EVALUATION_PROTOCOL.md`

## Project-Level Next Step

After reading required global files, inspect:

- `<repo>/.claude/WORKSPACE_INDEX.md`

If it does not exist and the task is non-trivial, create the project-local `.claude/` workspace according to `PROJECT_STRUCTURE_SPEC.md`.

## Rule

Read only what is needed for the current execution mode.
Do not blindly load all global documents.
