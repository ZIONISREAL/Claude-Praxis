#!/usr/bin/env bash
# Codex-Praxis Installer
# Idempotent installer/upgrader for the ~/.codex/ Praxis protocol system.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
TARGET_DIR="${HOME}/.codex"
FORCE=0
DRY_RUN=0
CHECK_ONLY=0
UPDATE_ONLY=0
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${TARGET_DIR}/.backup-codex-praxis-${TIMESTAMP}"
PRAXIS_SOURCE_FILE="${TARGET_DIR}/.praxis-source"

REQUIRED_FILES="
AGENTS.md
SYSTEM_INDEX.md
CODEX_INTEGRATION.md
CONSTITUTION.md
PROJECT_STRUCTURE_SPEC.md
EXECUTION_PROTOCOL.md
SUBAGENT_PROTOCOL.md
VALIDATION_PROTOCOL.md
COMPACT_PROTOCOL.md
SELF_EVALUATION_PROTOCOL.md
HANDOFF_SCHEMA.md
PLAN_SCHEMA.md
MODE_DECISION_SCHEMA.md
MIGRATION_PROTOCOL.md
PROJECT_WORKSPACE_INDEX_TEMPLATE.md
VERSION
install-codex.sh
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

log_info() { printf "[INFO]  %s\n" "$*"; }
log_warn() { printf "[WARN]  %s\n" "$*" >&2; }
log_error() { printf "[ERROR] %s\n" "$*" >&2; }
log_ok() { printf "[ OK ]  %s\n" "$*"; }
mark_pass() { printf "  [PASS] %s\n" "$1"; }
mark_fail() { printf "  [FAIL] %s\n" "$1"; }

usage() {
  cat <<EOF
Codex-Praxis Installer

Usage: install-codex.sh [OPTIONS]

Options:
  --from <dir>     Source directory of Praxis files (default: script directory)
  --target <dir>   Target Codex directory (default: ~/.codex)
  --force          Overwrite existing files after timestamped backup
  --dry-run        Print actions without executing
  --check          Verify install integrity; do not modify anything
  --update         Pull latest from recorded source and reinstall with --force
  -h, --help       Show this help

Behavior:
  - Installs Codex entrypoint AGENTS.md and Praxis protocol files into ~/.codex/.
  - Never overwrites auth.json, config.toml, SQLite state, sessions, logs, or plugins.
  - Existing protocol files are kept unless --force is passed.
  - --from records the source path in ~/.codex/.praxis-source for future --update calls.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --from)
      [ $# -ge 2 ] || { log_error "--from requires an argument"; exit 1; }
      SOURCE_DIR="$2"; shift 2 ;;
    --target)
      [ $# -ge 2 ] || { log_error "--target requires an argument"; exit 1; }
      TARGET_DIR="$2"
      BACKUP_DIR="${TARGET_DIR}/.backup-codex-praxis-${TIMESTAMP}"
      PRAXIS_SOURCE_FILE="${TARGET_DIR}/.praxis-source"
      shift 2 ;;
    --force) FORCE=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --check) CHECK_ONLY=1; shift ;;
    --update) UPDATE_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      log_error "Unknown argument: $1"
      usage >&2
      exit 1 ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "[DRY]  %s\n" "$*"
  else
    eval "$@"
  fi
}

ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    run "mkdir -p \"$dir\""
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

check_install() {
  local pass=1
  printf "Codex-Praxis integrity check - %s\n" "$TARGET_DIR"

  if [ ! -d "$TARGET_DIR" ]; then
    mark_fail "Target directory missing"
    return 2
  fi
  mark_pass "Target directory present"

  for file in $REQUIRED_FILES; do
    if [ -f "${TARGET_DIR}/${file}" ]; then
      mark_pass "$file"
    else
      mark_fail "$file"
      pass=0
    fi
  done

  for dir in $REQUIRED_DIRS; do
    if [ -d "${TARGET_DIR}/${dir}" ]; then
      mark_pass "${dir}/"
    else
      mark_fail "${dir}/"
      pass=0
    fi
  done

  for file in $REQUIRED_METRICS; do
    if [ -f "${TARGET_DIR}/metrics/${file}" ]; then
      mark_pass "metrics/${file}"
    else
      mark_fail "metrics/${file}"
      pass=0
    fi
  done

  if grep -q "Global entrypoint for Codex execution with Praxis" "${TARGET_DIR}/AGENTS.md" 2>/dev/null; then
    mark_pass "AGENTS.md is Codex-Praxis entrypoint"
  else
    mark_fail "AGENTS.md missing Codex-Praxis marker"
    pass=0
  fi

  if [ "$pass" -eq 1 ]; then
    log_ok "Integrity check: ALL PASS"
    return 0
  fi

  log_warn "Integrity check: FAILURES present"
  return 1
}

do_install() {
  if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source directory not found: $SOURCE_DIR"
    exit 1
  fi

  ensure_dir "$TARGET_DIR"

  for dir in $REQUIRED_DIRS; do
    ensure_dir "${TARGET_DIR}/${dir}"
  done

  for file in $REQUIRED_FILES; do
    install_file "$file"
  done

  for file in $REQUIRED_METRICS; do
    install_file "metrics/${file}"
  done

  local abs_source
  abs_source="$(cd "$SOURCE_DIR" && pwd)"
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "[DRY]  Write source to %s: %s\n" "$PRAXIS_SOURCE_FILE" "$abs_source"
  else
    printf '%s\n' "$abs_source" > "$PRAXIS_SOURCE_FILE"
    log_info "Source recorded: $PRAXIS_SOURCE_FILE"
  fi

  if [ -d "$BACKUP_DIR" ]; then
    log_info "Backups stored at: $BACKUP_DIR"
  fi
}

do_update() {
  if [ ! -f "$PRAXIS_SOURCE_FILE" ]; then
    log_error "No source recorded. Run install-codex.sh --from <dir> first."
    exit 1
  fi

  local recorded_source
  recorded_source="$(cat "$PRAXIS_SOURCE_FILE")"

  if [ ! -d "$recorded_source" ]; then
    log_error "Recorded source directory not found: $recorded_source"
    exit 1
  fi

  if [ -d "${recorded_source}/.git" ]; then
    log_info "Git repo detected; pulling latest..."
    if [ "$DRY_RUN" -eq 1 ]; then
      printf "[DRY]  cd \"%s\" && git fetch && git pull --ff-only\n" "$recorded_source"
    else
      (cd "$recorded_source" && git fetch && git pull --ff-only)
    fi
  else
    log_warn "Recorded source is not a git repo; reinstalling from local files."
  fi

  SOURCE_DIR="$recorded_source"
  FORCE=1
  do_install
  check_install
}

if [ "$CHECK_ONLY" -eq 1 ]; then
  check_install
  exit $?
fi

if [ "$UPDATE_ONLY" -eq 1 ]; then
  do_update
  exit $?
fi

do_install
if [ "$DRY_RUN" -eq 1 ]; then
  echo
  log_ok "Dry-run complete; no files were modified."
else
  echo
  check_install
fi
