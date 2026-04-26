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
