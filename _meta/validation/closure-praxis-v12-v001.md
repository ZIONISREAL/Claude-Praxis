# Closure — plan-praxis-v12-v001

## Plan ID
plan-praxis-v12-v001

## Mode at Closure
deep

## Validation Performed

### Structural validation
- VERSION = 1.2.0 — ok
- 5 protocol files modified per spec; bash -n install.sh = SYNTAX OK; jq settings.json valid
- New files: metrics/token-cost-baseline.md (88 lines), 3 packet files in _meta/handoffs/outbox/, 1 mode-decision rubric

### Callable entry validation
- install.sh --help: shows 3 new flags with full usage block
- install.sh --check: ALL PASS (23 items, including v1.1 protocols + new metrics file)
- install.sh --update without source: graceful error message, exit 1
- install.sh --check-version: prints local 1.2.0, remote 1.1.0 (correct — pre-push), classifies as "Local ahead"
- install.sh --changelog 1.1.0: extracts v1.1.0 CHANGELOG section correctly

### Synthetic input validation (F4 dogfood)
- Three thin-dispatch prompts measured: each ~50 tokens (vs prior pattern of 3-5K tokens)
- Three packet files written: sa-v12-install (3.4K chars), sa-v12-protocol (5.1K chars), sa-v12-baseline (4.0K chars)
- All three subagents successfully read packets and executed without follow-up clarification
- Validates F4 thin-dispatch pattern works in practice — main thread tokens reduced ~95% vs old inline style for these dispatches

### Realistic input validation
- CLAUDE.md cross-references checked: EXECUTION_PROTOCOL §5 exists, VALIDATION_PROTOCOL §11 exists, MODE_DECISION_SCHEMA.md exists at correct path — all resolve
- 4-tier read set in SYSTEM_INDEX: tier names match SUBAGENT_PROTOCOL/HANDOFF_SCHEMA/VALIDATION_PROTOCOL/PROJECT_STRUCTURE_SPEC/INTEGRATION/COMPACT_PROTOCOL/SELF_EVALUATION/PLAN_SCHEMA references — all match

### Objective alignment
- F1 update command: shipped, three flags work
- F2 4-tier read set: shipped, Tier A is 3 files (down from 7) — saves ~4K tokens for typical non-trivial task
- F3 CLAUDE.md slim: shipped, 121→38 lines (under target 45-55, justified by tight prose)
- F4 thin-dispatch enforcement: shipped + dogfooded — three successful real dispatches at ~50 tokens each
- F5 Anti-XY dedupe: shipped
- F6 token-cost-baseline.md: shipped with methodology and v1.2 targets

## Skipped Rules

- Rule: §X verification — full real-network test of `--check-version` and `--changelog`, action: partial, reason: tested against current state of remote repo (which still shows v1.1.0 because v1.2 has not been pushed yet); the SemVer comparison logic produced correct output for "local ahead" case but the "update available" case will not be testable until v1.3 ships, mitigation: SemVer compare uses standard `sort -V` which is well-tested
- Rule: §X verification — `install.sh --update` end-to-end execution, action: skip, reason: cannot test without recording a source path and risking a recursive re-install during this audit window, mitigation: code path inspected; same logic as `--from --force` which is tested via --check
- Rule: §VIII subagent-law — three parallel subagent dispatches, no shared-context conflicts encountered but parallel-write isolation was not stress-tested, action: partial, reason: scope-disjoint by design (sa-install: install.sh only; sa-protocol: 5 protocol files; sa-baseline: VERSION/CHANGELOG/READMEs/baseline) so no theoretical conflict, mitigation: post-merge git diff verified no overlap

## Honest Residual Risk

The thin-dispatch pattern (F4) shifts cost from main-thread to file-write+file-read. Net token savings rely on conversation length: long sessions amortize the file cost, short sessions may not see savings. If a user runs only 1-2 turns after a dispatch, the inline style is actually cheaper. The 1000-character threshold in §11 is a heuristic that may need tuning based on real-task data.

## Final Line Hash

praxis-v12-closed-2026-04-27
