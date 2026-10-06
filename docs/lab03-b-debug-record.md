# Lab 03-B Pipeline 除錯紀錄

實作日期：2026-10-06。Repository：`YTatADV/devops-lab`。

依手冊先合併 CI 失敗摘要，再建立四個各包含單一錯誤的分支，保存原始執行結果、定位原因、修正並重新執行 CI。練習 PR 關閉而不合併，只有失敗摘要與本紀錄保留於 main。

## 失敗摘要

[PR #9](https://github.com/YTatADV/devops-lab/pull/9) 已經四個必要檢查通過並 Squash 合併。test Job 最後新增 `if: failure()` 步驟，將 Node 版本及測試報告 Artifact 名稱寫入 `$GITHUB_STEP_SUMMARY`。

在 debug/3-test 的 Node 22、24 失敗執行中，測試報告上傳與「失敗摘要」步驟都成功完成。另以 `gh run rerun --failed --debug` 啟用 debug logging，確認 attempt 2 有 `##[debug]`，且兩個摘要步驟正常完成。

## 四個分支的除錯結果

| 分支與 PR | 原始現象 | 原因查找位置 | 錯誤原因 | 修正方式 |
| --- | --- | --- | --- | --- |
| `debug/1-yaml`，[PR #10](https://github.com/YTatADV/devops-lab/pull/10) | Workflow 解析失敗，沒有 Job 執行 | Actions 執行紀錄、`.github/workflows/ci.yml` | lint Job 的 `runs-on` 只有 3 個空白，與其他 Job 屬性不對齊 | 恢復 4 個空白縮排 |
| `debug/2-package`，[PR #11](https://github.com/YTatADV/devops-lab/pull/11) | lint 的 `npm ci` 失敗；Log 顯示 `ETARGET`、`No matching version found for left-pad@99.0.0` | lint Job → Run npm ci Log、package.json、package-lock.json | package.json 加入不存在的套件版本，且未同步 lockfile | 移除練習加入的 dependencies，恢復原本無第三方套件的設定 |
| `debug/3-test`，[PR #12](https://github.com/YTatADV/devops-lab/pull/12) | lint 通過，Node 22、24 的測試都失敗，build 跳過 | Run npm test Log、Annotations、下載的 test-report-node22、失敗摘要 | formatPrice 的預期值被改為 `TWD 1,234,568`，實際值為 `TWD 1,234,567` | 恢復正確預期值；兩個 Node 版本各 5 個測試全部通過 |
| `debug/4-env`，[PR #13](https://github.com/YTatADV/devops-lab/pull/13) | CI 全部通過，但下載 dist 後發現 version.txt 的 `name:` 為空白 | dist Artifact → version.txt、scripts/build.sh | `APP_NAME` 拼成 `APP_NMAE`，同時移除 `set -u`，未定義變數被展開為空字串 | 恢復 `${APP_NAME}` 與 `set -euo pipefail`，重新下載產物確認 `name: devops-lab` |

套件分支本次實際先報 ETARGET；lockfile 不一致是另外存在的設定問題，不代表這次 Log 先出現 lockfile 錯誤。

## 執行證據

| 分支 | 修正前 | 修正後 |
| --- | --- | --- |
| YAML | [37400135045](https://github.com/YTatADV/devops-lab/actions/runs/37400135045)：解析失敗、無 Job | [37400267309](https://github.com/YTatADV/devops-lab/actions/runs/37400267309) |
| 套件 | [37400146160](https://github.com/YTatADV/devops-lab/actions/runs/37400146160)：npm ci 失敗 | [37400274631](https://github.com/YTatADV/devops-lab/actions/runs/37400274631) |
| 測試 | [37400155613 attempt 1](https://github.com/YTatADV/devops-lab/actions/runs/37400155613/attempts/1)：測試失敗；[attempt 2](https://github.com/YTatADV/devops-lab/actions/runs/37400155613/attempts/2)：啟用 debug logging 重現失敗 | [37400287219](https://github.com/YTatADV/devops-lab/actions/runs/37400287219) |
| 環境變數 | [37400168440](https://github.com/YTatADV/devops-lab/actions/runs/37400168440)：綠燈，但 name 空白 | [37400291559](https://github.com/YTatADV/devops-lab/actions/runs/37400291559) |

原始測試 Artifact 已下載檢查，測試名稱為「formatPrice 加上千分位與幣別」，結果為 4 pass、1 fail。原始環境變數 Artifact 的 version.txt 為：

```text
name:
version: 0.1.0-local
commit: 3e6704d0baef0b1f84ad5c99c9a89e98df57cabe
status: ok
```

本機下載的驗證資料存放於 `.git/lab-evidence/`，不納入版本控制。GitHub Artifact 有 7 天保存期限，到期後仍可從本紀錄查閱原因與修正方式。

修正後四個分支的 lint、test (22)、test (24)、build 共 16 個必要檢查全部通過。已下載修正後的兩份測試報告及環境變數分支 dist，確認測試各 5 pass、0 fail，version.txt 包含 `name: devops-lab` 與 `status: ok`。

四個練習 PR #10–#13 已關閉而未合併，四個遠端及本機 debug 分支已移除。

## 驗收清單

- [x] main 上的 ci.yml 已包含「失敗摘要」步驟。
- [x] 四個除錯分支都已修復，修正後各項必要檢查通過。
- [x] 完成除錯紀錄表，附上修正前後的 GitHub 執行證據。
- [x] 實際啟用 debug logging 重跑失敗測試。
- [x] 能從 Workflow 解析、Step Log、測試報告及 Artifact 內容分別定位四種原因。
- [x] 練習 PR 未合併，四個練習分支已清理。

## 除錯順序

1. 先確認 Workflow 是否觸發、能否解析；沒有 Job 時先查 YAML。
2. 找出第一個失敗的 Job 與 Step，閱讀錯誤訊息及 Annotations。
3. 訊息不足時，以 Enable debug logging 重新執行；本次已在測試分支實際操作。
4. 綠燈但結果異常時，下載 Artifact 比對內容；必要時輸出非敏感變數。
5. 修正後重新執行四個必要檢查，並確認異常產物已恢復。

## Lab 03-A 收尾紀錄

| 項目 | 第一輪 | 第二輪 |
| --- | --- | --- |
| 執行紀錄 | [37283704192](https://github.com/YTatADV/devops-lab/actions/runs/37283704192) | [37283838212](https://github.com/YTatADV/devops-lab/actions/runs/37283838212) |
| createdAt 至 updatedAt 的經過時間，包含排程與結束處理 | 約 38 秒 | 約 32 秒 |
| lint Job 的 npm ci 時間，依秒級時間戳估算 | 約 1 秒 | 約 1 秒 |
| npm Cache | lint 未命中並儲存；後續 test、build 命中 | lint、test、build 命中 |

兩輪都成功；時間差約 6 秒，但不能僅憑兩次結果判定快取是唯一原因。第二輪的測試報告與 dist 已下載，version.txt 最後一行為 `status: ok`。

[PR #8](https://github.com/YTatADV/devops-lab/pull/8) 的失敗示範已驗證合併狀態為 BLOCKED；報告顯示 formatPrice 預期值為 `TWD 1,234,000`，實際為 `TWD 1,234,567`。PR 已關閉而未合併，遠端及本機 test/fail-demo 分支已移除。
