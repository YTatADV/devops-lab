#!/usr/bin/env bash
# 一次執行所有檢查，沒有 npm 時使用
set -euo pipefail

bash scripts/lint.sh
bash scripts/format-check.sh
bash scripts/test.sh
bash scripts/build.sh
echo "全部檢查完成"
