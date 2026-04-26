# MIGRATION_PROTOCOL.md

Rules for evolving the harness across versions without breaking existing project workspaces.

## 1. Versioning

Harness version follows SemVer: `MAJOR.MINOR.PATCH`.

- MAJOR: incompatible changes to file structure, schema fields, or protocol semantics
- MINOR: additive features (new files, new optional fields, new hooks)
- PATCH: clarifications, typo fixes, non-semantic edits

The current version is recorded in `~/.claude/VERSION`.

## 2. File Header Convention

Every harness file must begin with:

```
# <FILENAME>
<one-line description>

Harness version: <version when last meaningfully changed>
```

This lets the agent detect file-level drift across machines or versions.

## 3. Migration Triggers

A migration step is required when:

- User upgrades harness MAJOR version
- A field rename or structural change occurred in PROJECT_STRUCTURE_SPEC
- A protocol added a new mandatory field

## 4. Migration Steps

For each project workspace under user control:

1. Detect existing version (read `<repo>/.claude/VERSION` if present)
2. Compare with target version
3. Apply per-version migrators in order
4. Verify with non-code validation ladder
5. Record migration in `<repo>/.claude/logs/migration-log.md`

## 5. Migrator Format

Each migrator is a documented procedure (not yet executable code):

```
### v1.0.0 → v1.1.0
- New file: SELF_EVALUATION_PROTOCOL.md (additive, optional)
- New directory: metrics/ (additive)
- Action: copy from harness source if absent
```

Migrators are append-only. Once published, they must not be edited (only superseded).

## 6. Backward Compatibility Discipline

A new harness version must:
- Not silently change semantics of existing fields
- Not require renames without explicit migration
- Continue to read older project workspaces in degraded mode (warn, do not error)

## 7. Sync Mechanism

The harness may be synced across machines via:

a) Git: clone a repository containing the harness files into ~/.claude/, optionally as a worktree
b) Manual: copy the directory tree
c) Installer: re-run install.sh --from <new-source>

When using git: never commit secrets, MCP credentials, or ~/.claude/projects/ working data. Use a .gitignore.

Recommended .gitignore for ~/.claude/:
```
projects/
todos/
shell-snapshots/
ide/
statsig/
*.log
.credentials*
metrics/protocol-adherence.tsv
metrics/xy-incidents.md
metrics/failure-modes.md
metrics/improvement-backlog.md
_meta/last_compact_marker.txt
settings.local.json
```

The last 4 metrics files are personal usage data and should not sync across users.

## 8. Detection of Drift

On any session start, the agent may compare ~/.claude/VERSION against latest known. If user is behind, suggest running install.sh --from <source> --check.

Drift detection is advisory only.
