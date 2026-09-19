#!/usr/bin/env bash
set -Eeuo pipefail

# Long-form training version of a Japanese night-batch controller.
# It deliberately demonstrates locks, options, traps, staged files, checksums,
# manifests, retry decisions, return-code handling, and safe archive moves.

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
BUSINESS_DATE=${BUSINESS_DATE:-$(date +%Y%m%d)}
INPUT_FILE="$ROOT/data/input/transactions.csv"
OUTPUT_DIR="$ROOT/data/output"
OUTPUT_FILE="$OUTPUT_DIR/settlement-report.txt"
STAGED_OUTPUT="$OUTPUT_DIR/settlement-report.tmp"
ARCHIVE_DIR="$ROOT/data/archive/$BUSINESS_DATE"
REMOTE_DIR="$ROOT/data/remote"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/nightly-$BUSINESS_DATE.log"
STATUS_FILE="$LOG_DIR/nightly-$BUSINESS_DATE.status"
MANIFEST_FILE="$ARCHIVE_DIR/manifest.sha256"
LOCK_DIR="$ROOT/data/.nightly-$BUSINESS_DATE.lock"
BIN="$ROOT/bin/nightsettle"

RUN_MODE=${RUN_MODE:-normal}
CONTINUE_ON_ERROR=${CONTINUE_ON_ERROR:-N}
RETRY_UPLOAD=${RETRY_UPLOAD:-1}
DRY_RUN=${DRY_RUN:-N}

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }
set_status() { printf '%s=%s\n' "$1" "$2" >> "$STATUS_FILE"; }
fail() {
  local message=$1
  local code=${2:-1}
  set_status JOB_STATUS FAILED
  log "異常終了: $message (RC=$code)"
  exit "$code"
}
cleanup() {
  local rc=$?
  rm -f -- "$STAGED_OUTPUT"
  rmdir -- "$LOCK_DIR" 2>/dev/null || true
  if (( rc != 0 )); then log "終了処理: RC=$rc"; fi
}
trap cleanup EXIT

usage() {
  cat <<'EOF'
Usage: nightly-main.sh [--date YYYYMMDD] [--dry-run]
Environment: RUN_MODE=normal|recovery, CONTINUE_ON_ERROR=Y|N,
             RETRY_UPLOAD=0|1, DRY_RUN=Y|N
EOF
}

while (($# > 0)); do
  case "$1" in
    --date) [[ $# -ge 2 ]] || { usage >&2; exit 2; }; BUSINESS_DATE=$2; shift 2 ;;
    --dry-run) DRY_RUN=Y; shift ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

[[ "$BUSINESS_DATE" =~ ^[0-9]{8}$ ]] || exit 2
[[ "$RUN_MODE" == normal || "$RUN_MODE" == recovery ]] || exit 2
[[ "$CONTINUE_ON_ERROR" == Y || "$CONTINUE_ON_ERROR" == N ]] || exit 2
[[ "$RETRY_UPLOAD" =~ ^[01]$ ]] || exit 2
[[ "$DRY_RUN" == Y || "$DRY_RUN" == N ]] || exit 2

mkdir -p "$OUTPUT_DIR" "$ARCHIVE_DIR" "$REMOTE_DIR" "$LOG_DIR" || exit 20
exec > >(tee -a "$LOG_FILE") 2>&1
printf 'JOB_DATE=%s\n' "$BUSINESS_DATE" > "$STATUS_FILE"
set_status RUN_MODE "$RUN_MODE"
set_status JOB_STATUS STARTED

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  fail "同一営業日のロックが存在します: $LOCK_DIR" 14
fi

log "夜間バッチ開始: business_date=$BUSINESS_DATE mode=$RUN_MODE dry_run=$DRY_RUN"
[[ -x "$BIN" ]] || fail "COBOL実行ファイルがありません: $BIN" 20
[[ -f "$INPUT_FILE" ]] || fail "入力ファイルがありません" 11
[[ -s "$INPUT_FILE" ]] || fail "入力ファイルが空です" 12

if bash "$ROOT/scripts/linux/validate-input.sh" "$INPUT_FILE"; then
  :
else
  rc=$?
  fail "入力チェック" "$rc"
fi

if [[ "$DRY_RUN" == Y ]]; then
  log "DRY-RUN: COBOL処理、アーカイブ、送信をスキップします"
  set_status JOB_STATUS DRY_RUN
  exit 0
fi

rm -f -- "$STAGED_OUTPUT"
export NIGHT_INPUT="$INPUT_FILE"
export NIGHT_OUTPUT="$STAGED_OUTPUT"
log "COBOL処理開始"
if "$BIN"; then
  :
else
  rc=$?
  fail "COBOL処理" 21
fi
[[ -s "$STAGED_OUTPUT" ]] || fail "出力ファイルが空です" 22
mv -- "$STAGED_OUTPUT" "$OUTPUT_FILE" || fail "出力確定" 22

mkdir -p "$ARCHIVE_DIR" || fail "アーカイブディレクトリ" 23
cp -- "$INPUT_FILE" "$ARCHIVE_DIR/transactions.csv" || fail "入力アーカイブ" 23
cp -- "$OUTPUT_FILE" "$ARCHIVE_DIR/settlement-report.txt" || fail "出力アーカイブ" 23
sha256sum "$ARCHIVE_DIR/transactions.csv" "$ARCHIVE_DIR/settlement-report.txt" > "$MANIFEST_FILE" || fail "ハッシュ作成" 24
printf 'ARCHIVE_DATE=%s\n' "$BUSINESS_DATE" >> "$STATUS_FILE"
log "アーカイブ完了: $ARCHIVE_DIR"

upload_args=("$OUTPUT_FILE" "$REMOTE_DIR")
if (( RETRY_UPLOAD == 1 )); then
  log "送信開始: retry policy=1"
  if ! bash "$ROOT/scripts/linux/upload-sim.sh" "${upload_args[@]}"; then
    log "送信一次失敗、1回だけ再試行します"
    bash "$ROOT/scripts/linux/upload-sim.sh" "${upload_args[@]}" || fail "送信" 31
  fi
else
  bash "$ROOT/scripts/linux/upload-sim.sh" "${upload_args[@]}" || fail "送信" 31
fi

if [[ -f "$REMOTE_DIR/settlement-report.txt" ]]; then
  cmp -- "$OUTPUT_FILE" "$REMOTE_DIR/settlement-report.txt" || fail "送信後照合" 34
else
  fail "送信先ファイルがありません" 33
fi

set_status JOB_STATUS SUCCESS
set_status OUTPUT_SHA256 "$(sha256sum "$OUTPUT_FILE" | awk '{print $1}')"
log "夜間バッチ正常終了"
exit 0
