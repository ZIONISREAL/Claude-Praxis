# VALIDATION_PROTOCOL.md

Rules for validating work before completion.

## 1. Principle

No task is complete without evidence.

Implementation is not validation.

## 2. Validation Ladder

Attempt the strongest feasible validation:

1. syntax/static sanity
2. minimal unit validation
3. callable-entry validation
4. synthetic input validation
5. real or representative input validation
6. objective-alignment validation

## 3. Minimal Unit Validation

Validate the smallest meaningful component.

Examples:

- call a function directly
- parse config
- run smallest command
- execute isolated module
- test route registration

## 4. Callable Entry Validation

If a user-facing or system-facing entry exists, verify it can be invoked.

## 5. Synthetic Input Fallback

If no natural input exists, create a minimal hardcoded input when reasonable.

This proves the component can run and produce an inspectable output.

## 6. Realistic Input Validation

If realistic inputs exist, use them.

Prefer:

- real payload shape
- real file format
- real entrypoint
- representative edge case

## 7. Objective Verification

After technical validation, verify:

- did it solve the real objective?
- did it only satisfy literal proxy request?
- what remains unresolved?
- what evidence supports completion?

Record in:

```text
<repo>/.claude/validation/objective-verification.md
```

## 8. Evidence Recording

Record test evidence in:

```text
<repo>/.claude/validation/test-results.md
```

Include:

- command/method
- input
- output
- expected result
- observed result
- pass/fail
- limitations

## 9. If Validation Cannot Be Completed

Do not claim full completion.

Document:

- what was checked
- what could not be checked
- why
- remaining risk
- next validation step

## 10. Non-Code Validation

When the deliverable is documentation, configuration, design, schema, or process artifact (no executable code path), substitute the validation ladder with:

1. Structural validation
   - markdown/JSON/YAML/TOML parses successfully
   - schema fields all present per spec
   - file located in correct path per PROJECT_STRUCTURE_SPEC

2. Semantic validation
   - terminology consistent with `glossary.md` if present
   - cross-references resolve (linked files exist)
   - no contradiction with CONSTITUTION or higher-priority docs

3. Coverage validation
   - all required sections present
   - examples or templates render correctly when applicable

4. Reviewer-eye validation
   - read once as a fresh agent would in a future session
   - confirm: would this document trigger correct behavior under cold start?

5. Objective alignment
   - same as §7: did the document solve the real problem, not just the literal request?

Record evidence in `.claude/validation/test-results.md` with type tagged as `non-code`.

## 11. Closure Token

A claim of completion in standard, deep, or recovery mode must be structurally coupled to validation evidence by quoting a closure token.

### Token Construction

The closure token is a verbatim quote in the form:

```
[CLOSURE: plan=<plan-id> evidence=<path-to-validation-file> last-line="<last non-empty line of that file>" at=<ISO-8601 UTC>]
```

### Optional Verifier Field

The closure token may include an optional `verifier=PASS|FAIL` field at the end:

```
[CLOSURE: plan=<id> evidence=<path> last-line="<text>" at=<iso8601> verifier=PASS]
```

This field captures the result of `praxis doctor verify-closure <plan-id>` at the moment of token issuance. The agent SHOULD run the verifier immediately before constructing the token.

In standard / deep / recovery modes, an audit reader will treat an unverified closure (no `verifier=` field) with the same skepticism as a missing closure.

See `VERIFICATION_PROTOCOL.md` §4.

### Where the Token Must Appear

The token must appear in:

1. The agent's user-facing message that announces completion, AND
2. The corresponding `<repo>/.claude/validation/self-evaluation.md` entry for this task

### Token Validity Rules

- `evidence` must point to an existing file inside `<repo>/.claude/validation/` (typically `test-results.md`, `objective-verification.md`, or a closure-specific file)
- `last-line` must be the actual last non-empty line of that file at the moment of token construction
- `at` must be UTC and within 5 minutes of the message in which the token appears
- A token whose components do not all resolve is invalid and the closure claim is malformed

### Lightweight Mode Exemption

Lightweight mode does not produce a closure token. A simple "done" suffices, since no formal validation ladder applies. If a lightweight task is later discovered to have crossed into non-trivial territory, retroactively producing the artifact is required as a recovery action.

### Why This Rule Exists

LLMs under context pressure tend to skip the validation ladder and emit a verbal completion claim. The closure token couples the claim and the evidence at the syntactic layer: a token cannot be produced without first writing or reading the evidence file. This converts compliance from discipline-level to format-level.
