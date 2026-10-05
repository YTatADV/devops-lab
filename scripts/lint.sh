#!/usr/bin/env bash
# 語法檢查：有 Node.js 時用 node --check，沒有時只輸出訊息
set -euo pipefail

if command -v node >/dev/null 2>&1; then
  for f in src/*.js tests/*.js; do
    node --check "$f"
    echo "[lint] OK  $f"
  done
else
  echo "[lint] 未偵測到 Node.js，略過語法檢查（離線模式）"
fi
