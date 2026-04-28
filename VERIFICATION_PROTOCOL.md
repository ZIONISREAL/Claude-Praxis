# VERIFICATION_PROTOCOL.md

The third layer of Praxis execution discipline. Make missing or inconsistent state consequential.

## 1. The Three-Layer Model

Praxis execution discipline is structured in three layers:

| Layer | Question | v1.x Mechanism | Status |
|---|---|---|---|
| 1. Externalization | Is the execution state visible? | plan-as-files, mode-decision rubric, execution-log, validation files | high |
| 2. Reflection | Does the agent re-read its own state? | mandatory read order, self-evaluation, closure token's evidence pointer | medium |
| 3. Verification | Are missing or inconsistent states consequential? | `praxis doctor` CLI; `rules.json`; closure-token last-line + evidence-hash checks | medium-high where doctor rules exist |

Without layer 3, the first two are advisory. Layer 3 produces an executable PASS / FAIL judgment that an agent or human must reckon with before claiming closure.

## 2. The Doctor

`praxis doctor` is the verification engine. It is read-only — it judges, never modifies. Its inputs are the workspace files; its output is a list of rule judgments and an exit code.

```
praxis doctor check                         all rules against current workspace
praxis doctor check --json --brief          compact machine-readable control output
praxis doctor verify-closure <plan-id>      strict closure verification
praxis doctor verify-closure <plan-id> --json --brief
praxis doctor lint                          warnings only; never fails
praxis doctor list-rules                    enumerate registered rules from rules.json
praxis doctor explain <rule-id>             describe one rule
```

Exit codes:
- 0 — no errors
- 1 — at least one rule with severity `error` failed
- 2 — doctor itself encountered a system error

## 3. Rule IDs

All verifiable invariants in Praxis are identified by stable IDs in `rules.json`. The human-facing `RULE_REGISTRY.md` is a projection of that source. The format is `praxis.<area>.<rule>`. Stable rule IDs are public API and are governed by the harness MAJOR version per `MIGRATION_PROTOCOL.md`.

## 4. Closure Verification

The most important rule family is `praxis.closure.*`. A closure token in a completion claim is structurally meaningful only when its `last-line` field is verified against the actual last non-empty line of the referenced evidence file and, for v1.5+ tokens, its `sha256` field matches the full evidence file bytes.

The agent SHOULD run `praxis doctor verify-closure <plan-id>` immediately before issuing the closure token. The closure token's optional `verifier=` field captures the doctor's verdict at the moment of issuance:

```
[CLOSURE: plan=<id> evidence=<path> last-line="<text>" at=<iso8601> sha256=<hash> verifier=PASS]
```

If `verifier=PASS` is present, an audit reader can run `praxis doctor verify-closure <plan-id>` to reproduce the verdict. If the reproduction yields FAIL, the closure was either fabricated or the evidence file was modified after closure. With `sha256`, evidence mutation is detectable even when the last non-empty line is unchanged.

If `verifier=` is absent, the closure is unverified. In standard / deep / recovery modes, an unverified closure should be treated with the same skepticism as no closure at all.

## 5. Why Not Hard-Block

Praxis does not enforce verification at the tool layer (e.g., refuse to write a closure file if the verifier fails). Hard blocks would:

- Break under network or file-system anomalies
- Create new attack surfaces (a misbehaving doctor blocks all work)
- Conflict with lightweight mode's zero-friction principle

Instead the doctor is a read-only judge, not a file-system gate. For agents operating under standard / deep / recovery Praxis control, `praxis doctor check --json --brief` and `praxis doctor verify-closure <plan-id> --json --brief` are part of the pre-completion control flow: if the JSON reports `exit_code != 0`, the agent must repair the artifact or record the verification skip before claiming closure.

Verification is consequential because:

- An audit reader will run the doctor. A FAIL is publicly visible.
- Self-evaluation must record skipped verifications.
- Future audit subagents (v1.5+) may dispatch automatically.

## 6. Lightweight Mode

Lightweight tasks do not produce closure tokens, plan files, or mode-decision rubrics. The doctor returns N/A for all closure rules in lightweight workspaces. The verification layer applies only when the externalization layer has been engaged.

## 7. Adding New Rules

See `RULE_REGISTRY.md` "How To Add a New Rule". The lifecycle is: add metadata to `rules.json` → implement the check in `praxis` → reference the rule from at least one protocol → after one minor release, eligible for promotion to stable.
