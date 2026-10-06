#!/usr/bin/env bash
# 建置：把網站檔案複製到 dist/，並寫入版本資訊，只需要 bash
set -euo pipefail

APP_NAME="devops-lab"
VERSION="${APP_VERSION:-0.1.0-local}"

rm -rf dist
mkdir -p dist
cp src/index.html src/app.js dist/

cat > dist/version.txt <<EOF
name: ${APP_NAME}
version: ${VERSION}
commit: ${GITHUB_SHA:-local}
status: ok
EOF

echo "[build] ${APP_NAME} ${VERSION} 建置完成"
ls dist
