#!/usr/bin/env bash
set -u

input_file=${1:?"usage: validate-input.sh INPUT_FILE"}

if [[ ! -f "$input_file" ]]; then
  echo "入力ファイルがありません: $input_file" >&2
  exit 11
fi

if [[ ! -s "$input_file" ]]; then
  echo "入力ファイルが空です: $input_file" >&2
  exit 12
fi

line_no=0
while IFS= read -r line || [[ -n "$line" ]]; do
  ((line_no += 1))
  IFS=',' read -r account amount status extra <<< "$line"
  if [[ -n "$extra" || ! "$account" =~ ^[0-9]{6}$ || ! "$amount" =~ ^[0-9]{10}$ || ! "$status" =~ ^(OK|ER)$ ]]; then
    echo "入力形式エラー: ${line_no}行目" >&2
    exit 13
  fi
done < "$input_file"

echo "入力チェック正常: ${line_no}件"
exit 0
