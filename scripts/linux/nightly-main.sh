#!/usr/bin/env bash
set -u

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
BUSINESS_DATE=${BUSINESS_DATE:-$(date +%Y%m%d)}
INPUT_FILE="$ROOT/data/input/transactions.csv"
OUTPUT_FILE="$ROOT/data/output/settlement-report.txt"
ARCHIVE_DIR="$ROOT/data/archive/$BUSINESS_DATE"
REMOTE_DIR="$ROOT/data/remote"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/nightly-$BUSINESS_DATE.log"
BIN="$ROOT/bin/nightsettle"

mkdir -p "$ROOT/data/output" "$ARCHIVE_DIR" "$REMOTE_DIR" "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }
fail() {
  local message=$1
  local code=${2:-1}
  log "異常終了: $message (RC=$code)"
  exit "$code"
}

log "夜間バッチ開始: business_date=$BUSINESS_DATE"
bash "$ROOT/scripts/linux/validate-input.sh" "$INPUT_FILE" || {
  rc=$?
  fail "入力チェック" "$rc"
}

export NIGHT_INPUT="$INPUT_FILE"
export NIGHT_OUTPUT="$OUTPUT_FILE"
"$BIN" || fail "COBOL処理" 21

[[ -s "$OUTPUT_FILE" ]] || fail "出力ファイルが空です" 22
cp -- "$INPUT_FILE" "$ARCHIVE_DIR/transactions.csv" || fail "入力アーカイブ" 23
cp -- "$OUTPUT_FILE" "$ARCHIVE_DIR/settlement-report.txt" || fail "出力アーカイブ" 23

bash "$ROOT/scripts/linux/upload-sim.sh" "$OUTPUT_FILE" "$REMOTE_DIR" || fail "送信" 31
log "夜間バッチ正常終了"
exit 0
