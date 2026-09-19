#!/usr/bin/env bash
set -Eeuo pipefail

input_file=${1:?'usage: validate-input.sh INPUT_FILE [MAX_RECORDS]'}
max_records=${2:-10000}
declare -A seen_accounts=()

[[ "$max_records" =~ ^[0-9]+$ ]] || {
  echo "最大件数が不正です: $max_records" >&2
  exit 14
}
[[ -f "$input_file" ]] || {
  echo "入力ファイルがありません: $input_file" >&2
  exit 11
}
[[ -s "$input_file" ]] || {
  echo "入力ファイルが空です: $input_file" >&2
  exit 12
}

line_no=0
ok_count=0
error_count=0
total_amount=0
while IFS= read -r line || [[ -n "$line" ]]; do
  ((line_no += 1))
  if (( line_no > max_records )); then
    echo "最大件数超過: ${line_no}行目" >&2
    exit 15
  fi
  [[ -n "$line" ]] || {
    echo "空行エラー: ${line_no}行目" >&2
    exit 13
  }

  IFS=',' read -r account amount status extra <<< "$line"
  if [[ -n "${extra:-}" || ! "$account" =~ ^[0-9]{6}$ || ! "$amount" =~ ^[0-9]{10}$ || ! "$status" =~ ^(OK|ER)$ ]]; then
    echo "入力形式エラー: ${line_no}行目" >&2
    exit 13
  fi
  if [[ -n "${seen_accounts[$account]:-}" ]]; then
    echo "重複アカウントエラー: ${line_no}行目 account=$account" >&2
    exit 16
  fi
  seen_accounts["$account"]=1
  total_amount=$((total_amount + 10#$amount))
  if [[ "$status" == OK ]]; then
    ((ok_count += 1))
  else
    ((error_count += 1))
  fi
done < "$input_file"

(( line_no > 0 )) || {
  echo "レコードがありません" >&2
  exit 12
}
printf '入力チェック正常: %d件 OK=%d ER=%d TOTAL=%010d\n' \
  "$line_no" "$ok_count" "$error_count" "$total_amount"
exit 0
