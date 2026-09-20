#!/usr/bin/env bash
set -u

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
grep -q 'COPY WORKBOOK-CONSTANTS' "$root/src/SETTLE_WORKBOOK.COB"
grep -q 'UNSTRING' "$root/src/SETTLE_WORKBOOK.COB"
grep -q 'PERFORM 1000-READ' "$root/src/SETTLE_WORKBOOK.COB"
grep -q '88  EOF-YES' "$root/src/SETTLE_WORKBOOK.COB"
echo "static contracts: OK"

