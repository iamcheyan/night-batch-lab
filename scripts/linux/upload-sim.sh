#!/usr/bin/env bash
set -Eeuo pipefail

source_file=${1:?'usage: upload-sim.sh FILE REMOTE_DIR [REMOTE_NAME]'}
remote_dir=${2:?'usage: upload-sim.sh FILE REMOTE_DIR [REMOTE_NAME]'}
remote_name=${3:-$(basename -- "$source_file")}
fail_after_copy=${FAIL_AFTER_COPY:-N}

[[ -f "$source_file" ]] || {
  echo "送信対象がありません: $source_file" >&2
  exit 31
}
[[ -r "$source_file" ]] || {
  echo "送信対象を読めません: $source_file" >&2
  exit 32
}
[[ -n "$remote_name" && "$remote_name" != */* ]] || {
  echo "送信先ファイル名が不正です: $remote_name" >&2
  exit 33
}

mkdir -p -- "$remote_dir" || exit 34
temporary_file="$remote_dir/.${remote_name}.part"
remote_file="$remote_dir/$remote_name"
rm -f -- "$temporary_file"

cleanup() { rm -f -- "$temporary_file"; }
trap cleanup EXIT

cp -- "$source_file" "$temporary_file" || exit 35
if [[ "$fail_after_copy" == Y ]]; then
  echo "送信シミュレーション強制失敗: $remote_name" >&2
  exit 36
fi
[[ -s "$temporary_file" ]] || {
  echo "一時送信ファイルが空です: $temporary_file" >&2
  exit 37
}
mv -f -- "$temporary_file" "$remote_file" || exit 38
trap - EXIT

source_size=$(stat -c '%s' -- "$source_file")
remote_size=$(stat -c '%s' -- "$remote_file")
[[ "$source_size" == "$remote_size" ]] || {
  echo "送信後サイズ不一致: source=$source_size remote=$remote_size" >&2
  exit 39
}
printf '送信シミュレーション完了: %s size=%s\n' "$remote_name" "$remote_size"
exit 0
