#!/usr/bin/env bash
# 用法：./scripts/smoke-test.sh <環境名稱>
set -euo pipefail

DIR="deploy/$1"
test -f "$DIR/index.html" || { echo "缺少 index.html"; exit 1; }
grep -q '^status: ok$' "$DIR/version.txt" || { echo "健康檢查失敗"; exit 1; }
echo "Smoke test 通過"
