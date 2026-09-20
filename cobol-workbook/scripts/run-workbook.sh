#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/bin/settle-workbook"
INPUT="${INPUT_FILE:-$ROOT/data/input/transactions.csv}"
OUTPUT="$ROOT/data/output/settlement-report.txt"

mkdir -p "$(dirname "$OUTPUT")"
if [[ ! -s "$INPUT" ]]; then
  echo "入力ファイルがありません: $INPUT" >&2
  exit 10
fi

rm -f "$OUTPUT"
NIGHT_INPUT="$INPUT" NIGHT_OUTPUT="$OUTPUT" "$BIN"
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "COBOL処理失敗: rc=$rc" >&2
  exit "$rc"
fi

[[ -s "$OUTPUT" ]] || { echo "出力ファイルが空です" >&2; exit 11; }
echo "COBOL処理成功: $OUTPUT"
sed -n '1,20p' "$OUTPUT"
