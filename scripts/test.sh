#!/usr/bin/env bash
# 單元測試：有 Node.js 時執行內建的 node --test，沒有時只輸出訊息
set -euo pipefail

mkdir -p reports
if command -v node >/dev/null 2>&1; then
  node --test tests/*.test.js 2>&1 | tee reports/test-results.txt
else
  echo "[test] 未偵測到 Node.js，略過單元測試（離線模式）" | tee reports/test-results.txt
fi
