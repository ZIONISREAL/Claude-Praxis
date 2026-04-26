#!/usr/bin/env bash
# Claude Code Harness Installer
# Idempotent installer/upgrader for the ~/.claude/ harness system.

set -euo pipefail

# ---------- Defaults ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/harness"
TARGET_DIR="${HOME}/.claude"
FORCE=0
DRY_RUN=0
CHECK_ONLY=0
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${TARGET_DIR}/.backup-${TIMESTAMP}"

# ---------- Required harness inventory ----------
REQUIRED_FILES="
CLAUDE.md
SYSTEM_INDEX.md
INTEGRATION.md
CONSTITUTION.md
PROJECT_STRUCTURE_SPEC.md
EXECUTION_PROTOCOL.md
SUBAGENT_PROTOCOL.md
VALIDATION_PROTOCOL.md
COMPACT_PROTOCOL.md
SELF_EVALUATION_PROTOCOL.md
MIGRATION_PROTOCOL.md
HANDOFF_SCHEMA.md
PLAN_SCHEMA.md
PROJECT_WORKSPACE_INDEX_TEMPLATE.md
VERSION
"

REQUIRED_METRICS="
README.md
failure-modes.md
improvement-backlog.md
protocol-adherence.tsv
xy-incidents.md
"

REQUIRED_DIRS="
metrics
_meta
"

# ---------- Color setup ----------
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  C_RESET="$(tput sgr0)"
  C_RED="$(tput setaf 1)"
  C_GREEN="$(tput setaf 2)"
  C_YELLOW="$(tput setaf 3)"
  C_BLUE="$(tput setaf 4)"
  C_BOLD="$(tput bold)"
else
  C_RESET=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_BOLD=""
fi

log_info()  { printf "%s[INFO]%s  %s\n"  "$C_BLUE"   "$C_RESET" "$*"; }
log_warn()  { printf "%s[WARN]%s  %s\n"  "$C_YELLOW" "$C_RESET" "$*" >&2; }
log_error() { printf "%s[ERROR]%s %s\n"  "$C_RED"    "$C_RESET" "$*" >&2; }
log_ok()    { printf "%s[ OK ]%s  %s\n"  "$C_GREEN"  "$C_RESET" "$*"; }

mark_pass() { printf "  %s[PASS]%s %s\n" "$C_GREEN" "$C_RESET" "$1"; }
mark_fail() { printf "  %s[FAIL]%s %s\n" "$C_RED"   "$C_RESET" "$1"; }

# ---------- Usage ----------
usage() {
  cat <<EOF
${C_BOLD}Claude Code Harness Installer${C_RESET}

Usage: install.sh [OPTIONS]

Options:
  --from <dir>    Source directory of harness files (default: ./harness/)
  --force         Overwrite existing files (creates backup at ~/.claude/.backup-<ts>/)
  --dry-run       Print actions without executing
  --check         Verify install integrity; do not modify anything
  -h, --help      Show this help

Behavior:
  - Fresh install if ~/.claude/ is absent.
  - Upgrade install if ~/.claude/ exists (only writes missing harness files).
  - settings.json is never overwritten; a sample is written to settings.json.harness-sample.

Exit codes: 0 success, 1 user error, 2 system error
EOF
}

# ---------- Arg parse ----------
while [ $# -gt 0 ]; do
  case "$1" in
    --from)
      [ $# -ge 2 ] || { log_error "--from requires an argument"; exit 1; }
      SOURCE_DIR="$2"; shift 2 ;;
    --force)    FORCE=1; shift ;;
    --dry-run)  DRY_RUN=1; shift ;;
    --check)    CHECK_ONLY=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)
      log_error "Unknown argument: $1"
      usage >&2
      exit 1 ;;
  esac
done

# ---------- Helpers ----------
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "%s[DRY]%s  %s\n" "$C_YELLOW" "$C_RESET" "$*"
  else
    eval "$@"
  fi
}

ensure_dir() {
  local d="$1"
  if [ ! -d "$d" ]; then
    run "mkdir -p \"$d\""
  fi
}

backup_file() {
  local rel="$1"
  local src="${TARGET_DIR}/${rel}"
  if [ -e "$src" ]; then
    local dest="${BACKUP_DIR}/${rel}"
    ensure_dir "$(dirname "$dest")"
    run "cp -p \"$src\" \"$dest\""
  fi
}

install_file() {
  # install_file <relative path>
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${TARGET_DIR}/${rel}"

  if [ ! -f "$src" ]; then
    log_warn "Source missing: $rel (skipped)"
    return 0
  fi

  if [ -f "$dst" ]; then
    if [ "$FORCE" -eq 1 ]; then
      backup_file "$rel"
      log_info "Overwriting (backed up): $rel"
      ensure_dir "$(dirname "$dst")"
      run "cp -p \"$src\" \"$dst\""
    else
      log_info "Exists, keeping: $rel"
    fi
  else
    log_info "Installing: $rel"
    ensure_dir "$(dirname "$dst")"
    run "cp -p \"$src\" \"$dst\""
  fi
}

# ---------- Check mode ----------
check_install() {
  local pass=1
  printf "%sHarness integrity check%s — %s\n" "$C_BOLD" "$C_RESET" "$TARGET_DIR"

  if [ ! -d "$TARGET_DIR" ]; then
    mark_fail "Target directory ~/.claude/ missing"
    return 2
  fi
  mark_pass "Target directory present"

  # Required top-level files
  for f in $REQUIRED_FILES; do
    if [ -f "${TARGET_DIR}/${f}" ]; then
      mark_pass "$f"
    else
      mark_fail "$f"
      pass=0
    fi
  done

  # Required dirs
  for d in $REQUIRED_DIRS; do
    if [ -d "${TARGET_DIR}/${d}" ]; then
      mark_pass "${d}/"
    else
      mark_fail "${d}/"
      pass=0
    fi
  done

  # Metrics inventory
  for f in $REQUIRED_METRICS; do
    if [ -f "${TARGET_DIR}/metrics/${f}" ]; then
      mark_pass "metrics/${f}"
    else
      mark_fail "metrics/${f}"
      pass=0
    fi
  done

  # settings.json: existence, JSON validity, hooks presence
  local settings="${TARGET_DIR}/settings.json"
  if [ -f "$settings" ]; then
    mark_pass "settings.json present"
    if command -v jq >/dev/null 2>&1; then
      if jq empty "$settings" >/dev/null 2>&1; then
        mark_pass "settings.json valid JSON"
        if jq -e '.hooks' "$settings" >/dev/null 2>&1; then
          mark_pass "settings.json contains .hooks"
        else
          mark_fail "settings.json missing .hooks key"
          pass=0
        fi
      else
        mark_fail "settings.json invalid JSON"
        pass=0
      fi
    elif command -v python3 >/dev/null 2>&1; then
      if python3 -c "import json,sys; d=json.load(open('$settings')); sys.exit(0 if 'hooks' in d else 3)" 2>/dev/null; then
        mark_pass "settings.json valid JSON with .hooks (python3)"
      else
        rc=$?
        if [ "$rc" -eq 3 ]; then
          mark_fail "settings.json valid JSON but missing .hooks"
          pass=0
        else
          mark_fail "settings.json invalid JSON"
          pass=0
        fi
      fi
    else
      log_warn "Neither jq nor python3 available; skipping JSON validation"
    fi
  else
    mark_fail "settings.json absent"
    pass=0
  fi

  if [ "$pass" -eq 1 ]; then
    log_ok "Integrity check: ALL PASS"
    return 0
  else
    log_warn "Integrity check: FAILURES present"
    return 0
  fi
}

# ---------- Install flow ----------
do_install() {
  if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source directory not found: $SOURCE_DIR"
    log_error "Pass --from <dir> pointing at the harness source tree."
    exit 1
  fi

  local mode="upgrade"
  if [ ! -d "$TARGET_DIR" ]; then
    mode="fresh"
    log_info "Fresh install: creating $TARGET_DIR"
    ensure_dir "$TARGET_DIR"
  else
    log_info "Existing ~/.claude/ detected — upgrade mode (force=$FORCE)"
  fi

  # Directories
  for d in $REQUIRED_DIRS; do
    ensure_dir "${TARGET_DIR}/${d}"
  done

  # Top-level files
  for f in $REQUIRED_FILES; do
    install_file "$f"
  done

  # Metrics files
  for f in $REQUIRED_METRICS; do
    install_file "metrics/${f}"
  done

  # settings.json — never overwrite. The public repo ships settings.json.sample.
  local settings_src="${SOURCE_DIR}/settings.json"
  if [ ! -f "$settings_src" ] && [ -f "${SOURCE_DIR}/settings.json.sample" ]; then
    settings_src="${SOURCE_DIR}/settings.json.sample"
  fi
  local settings_dst="${TARGET_DIR}/settings.json"
  if [ -f "$settings_src" ]; then
    if [ -f "$settings_dst" ]; then
      log_warn "settings.json exists; not overwriting."
      log_warn "Sample written to settings.json.harness-sample — please merge .hooks manually."
      run "cp -p \"$settings_src\" \"${TARGET_DIR}/settings.json.harness-sample\""
    else
      log_info "Installing settings.json"
      run "cp -p \"$settings_src\" \"$settings_dst\""
    fi
  fi

  log_ok "Install complete (mode=$mode, dry_run=$DRY_RUN)"
  if [ -d "$BACKUP_DIR" ]; then
    log_info "Backups stored at: $BACKUP_DIR"
  fi
}

# ---------- Main ----------
main() {
  if [ "$CHECK_ONLY" -eq 1 ]; then
    check_install
    exit $?
  fi
  do_install
  echo
  check_install || true
}

main "$@"
