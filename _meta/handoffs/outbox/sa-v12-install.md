# Subagent Task Packet — sa-v12-install

## Task ID
sa-v12-install

## Parent Plan
/Users/zion/.claude/_meta/plan-v003.md

## Role
implementer

## Model
sonnet

## Effort
medium

## Objective
Extend `/Users/zion/.claude/install.sh` with three new flags: `--update`, `--check-version`, `--changelog`. Provide one-command update for users who installed via git clone.

## Required Inputs
- /Users/zion/.claude/install.sh (current version, ~311 lines, read first)
- /Users/zion/.claude/VERSION (currently 1.1.0)

## Allowed Reads
- /Users/zion/.claude/install.sh
- /Users/zion/.claude/VERSION
- /Users/zion/.claude/CHANGELOG.md (for `--changelog` test)

## Allowed Writes
- /Users/zion/.claude/install.sh (extend, do not rewrite)
- /Users/zion/.claude/.praxis-source (create on `--update` invocation; documented in spec)

## Forbidden
- Do NOT touch protocol .md files
- Do NOT modify VERSION yet (handled by sa-v12-baseline)
- Do NOT change existing flag behavior — additive only

## Constraints
- POSIX bash 3.2 compatible
- Functions must integrate with existing log_info/log_warn/log_error
- All new flags must work with --dry-run
- Use git when source is a git repo; fall back gracefully if not
- Network ops must time out (curl with -m 10)
- All curl calls to public github.com endpoints; no auth required

## Specification

### Flag 1: `--update`

Behavior:
1. Check `~/.claude/.praxis-source` exists. If not, error: "No source recorded. Run `install.sh --from <dir>` first to register source."
2. Read source path/URL from that file.
3. If source is a git working tree (`.git` dir exists): `cd <source> && git fetch && git pull --ff-only`. On conflict, error and exit 1.
4. If source is non-git: print warning "Source is not a git repo; manual update required." Exit 1.
5. Re-execute `install.sh --from <source> --force` (which already implements backup + overwrite).
6. After: `install.sh --check` to confirm.

Also: on every `--from <dir>` install, write source path (absolute) to `~/.claude/.praxis-source`. If file exists, overwrite (latest source wins).

### Flag 2: `--check-version`

Behavior:
1. Print local VERSION: `cat ~/.claude/VERSION`.
2. Curl remote `https://raw.githubusercontent.com/ZIONISREAL/Claude-Praxis/main/VERSION` with `-fsSL -m 10`.
3. Print remote version.
4. Compare; print one of:
   - "Up to date." (equal)
   - "Update available: <local> → <remote>." (local < remote by SemVer compare)
   - "Local ahead of remote: <local> > <remote>." (rare; pre-release)
5. SemVer compare: simple `sort -V` based check. Fine for MAJOR.MINOR.PATCH.

Exit 0 always (informational).

### Flag 3: `--changelog [version]`

Behavior:
1. If no version arg, default to remote latest.
2. Curl `https://raw.githubusercontent.com/ZIONISREAL/Claude-Praxis/main/CHANGELOG.md`.
3. Extract section starting with `## [<version>]` and ending at next `## [` line. Print to stdout.
4. If version not found, print error and list available versions.

### Help text update

Update `--help` output to include new flags. Maintain existing format.

## Done Criteria
- 3 new flags implemented and parse correctly
- Existing flags unaffected (--from / --force / --dry-run / --check / -h still work)
- `bash -n install.sh` clean
- Test invocations:
  - `./install.sh --help` shows new flags
  - `./install.sh --check-version` returns sensible output (may show "remote unreachable" in sandbox; that's acceptable as long as exit is graceful)
  - `./install.sh --update` without `.praxis-source` shows clear error
  - `./install.sh --changelog 1.1.0` extracts the v1.1.0 section
- Line count: install.sh expected to grow from ~311 to ~450-500

## Escalation Conditions
- If existing install.sh has structural issues that prevent additive changes → report, do not refactor
- If `.praxis-source` mechanism conflicts with macOS gatekeeper or other sandboxing → report

## Required Output (≤120 words)
1. Final install.sh line count (before / after)
2. Three flags implemented? confirm each
3. bash -n result
4. Test invocation results (`--help`, `--check-version`, `--update` with no source)
5. Any deviation
