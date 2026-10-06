#!/usr/bin/env bash
# 模擬部署：在目前 Runner 解壓縮 Release 套件。
set -euo pipefail

ENV_NAME="$1"
VERSION="$2"
PACKAGE="$3"

case "$ENV_NAME" in
  staging|production) ;;
  *) echo "不支援的環境：$ENV_NAME"; exit 1 ;;
esac

test -f "$PACKAGE" || { echo "找不到套件 $PACKAGE"; exit 1; }
echo "開始部署 $PACKAGE（版本 $VERSION）到 $ENV_NAME"
sha256sum "$PACKAGE"
mkdir -p "deploy/$ENV_NAME"
unzip -oq "$PACKAGE" -d "deploy/$ENV_NAME"
echo "$VERSION" > "deploy/$ENV_NAME/DEPLOYED_VERSION"
cat "deploy/$ENV_NAME/version.txt"
echo "部署完成"
