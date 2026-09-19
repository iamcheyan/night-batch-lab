#!/usr/bin/env bash
set -u

source_file=${1:?"usage: upload-sim.sh FILE"}
remote_dir=${2:?"usage: upload-sim.sh FILE REMOTE_DIR"}

if [[ ! -f "$source_file" ]]; then
  echo "送信対象がありません: $source_file" >&2
  exit 31
fi

mkdir -p "$remote_dir" || exit 32
cp -- "$source_file" "$remote_dir/" || exit 33
echo "送信シミュレーション完了: $(basename "$source_file")"
exit 0
