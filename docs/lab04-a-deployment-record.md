# Lab 04-A 部署與回復紀錄

實作日期：2026-10-06。Repository：`YTatADV/devops-lab`。

本 Lab 使用手冊的模擬部署：套件在 GitHub 雲端 Runner 上解壓縮並驗證，不另架設網站主機；Job 結束後部署檔案不持續存在。

## 環境與流程

- staging 不設保護規則。
- production 指定 YTatADV 為 required reviewer，只允許 main 分支。個人練習允許自行核准。
- Deploy 只在 build Job 執行一次建置，將 app.zip 上傳為 Artifact；Staging 與 Production 下載同一份套件。
- Production 等待指定 reviewer 核准，成功部署並通過 Smoke Test 才建立附有 app.zip 的 Release。
- Deploy 與 Rollback 的 Production Job 共用 `deploy-production` concurrency group，`cancel-in-progress: false`。
- Rollback 下載指定 Release 的既有 app.zip，不重新建置，也必須通過 Production 核准。

[PR #15](https://github.com/YTatADV/devops-lab/pull/15) 已經必要 CI 檢查通過並合併，新增 deploy.sh、smoke-test.sh、deploy.yml 與 rollback.yml。兩個 shell 腳本的 Git 執行權限為 100755。

建置前設定 APP_VERSION，讓 version.txt 與 Release 版本一致。沿用目前 CI 的 Action 版本，download-artifact 使用官方目前範例的 v8。docs 專用變更略過 Deploy，PR CI 仍完整執行，避免保存實作紀錄時再次部署。

## 兩次發布

| 版本 | 執行紀錄 | 結果與內容 |
| --- | --- | --- |
| [v1.0.1](https://github.com/YTatADV/devops-lab/releases/tag/v1.0.1) | [Deploy 37401581096](https://github.com/YTatADV/devops-lab/actions/runs/37401581096) | Build、Staging、Production、Release 全部成功；首頁為原版文字 |
| [v1.0.2](https://github.com/YTatADV/devops-lab/releases/tag/v1.0.2) | [Deploy 37401750323](https://github.com/YTatADV/devops-lab/actions/runs/37401750323) | 全部成功；[PR #16](https://github.com/YTatADV/devops-lab/pull/16) 將首頁文字改成第二版 |

兩個 Release 都附有 app.zip。兩次都先保存 Production 等待核准的狀態，再由指定的 YTatADV reviewer 透過 GitHub API 核准；review history 的 state 為 approved。

第一版套件 SHA-256：

```text
1b9560c3e3b36da292e24f240ddae0358245048e83e7c6279fa1c5bf7d2c25c4
```

第二版套件 SHA-256：

```text
b703f5e20aa7370024ff43ed66c6a22a3bb1944c561b261427326c1aeff80f5e
```

每個版本的 Build、Staging、Production Log 及 Release asset digest 都對應相同 SHA-256，證明環境之間沒有重新建置套件。

## 回復演練

第二版部署成功後，從 main 手動觸發 Rollback，輸入 version=v1.0.1、environment=production。

[Rollback 37401865094](https://github.com/YTatADV/devops-lab/actions/runs/37401865094) 已成功。Production 同樣先等待核准，再由 YTatADV 放行。Log 顯示：

```text
開始部署 app.zip（版本 v1.0.1）到 production
version: 1.0.1
Smoke test 通過
```

回復時的套件 SHA-256 與第一版完全一致。此演練回復部署套件；main 的原始碼仍保留第二版。後續若再觸發正常 Deploy，會部署 main 當時的內容。

## 驗證與討論

本機已驗證 bash 語法、正常套件 Smoke Test、status: broken 被拒絕、缺少 index.html 被拒絕。沒有執行手冊選做的「故意合併異常產物再 Revert」雲端演練。

緊急恢復服務且既有套件仍相容時可重新部署舊版；若要修正 main 的錯誤原始碼、避免下一次部署重新帶入問題，應透過 Revert PR 或修正 PR 再走正常 CI/CD。資料庫已變更時，還需確認舊程式是否相容，不應假設應用程式回復會自動回復資料或 schema。

本機驗證資料保存在 `.git/lab-evidence/04-a/`，不提交套件及操作暫存資料。

## 驗收清單

- [x] staging 與 production 已建立，Production 需要 reviewer 核准。
- [x] CD 每次只建置一次，兩個環境部署同一份 app.zip。
- [x] 成功部署後建立 Release 並附上套件，已有 v1.0.1 與 v1.0.2。
- [x] Rollback 成功回復到 v1.0.1，Smoke Test 通過。
