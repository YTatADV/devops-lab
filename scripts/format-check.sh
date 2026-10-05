#!/usr/bin/env bash
# 格式檢查：不允許 Tab 縮排與行尾空白，只需要 bash 與 grep
set -euo pipefail

TAB=$(printf '\t')
fail=0

if grep -n "$TAB" src/* tests/*; then
  echo "[format] 發現 Tab，請改用空白縮排"
  fail=1
fi
if grep -nE ' +$' src/* tests/*; then
  echo "[format] 發現行尾空白"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "[format] OK"
fi
exit "$fail"
