# Lab 03 本機 Runner 操作

本專案的 PR CI 使用本機 Windows x64 Runner，名稱 `NB110245-lab03`，標籤為 `self-hosted`、`Windows`、`X64`、`lab`。Runner 註冊於 `YTatADV/devops-lab`，安裝路徑是 `D:\actions-runner-lab06`，保留供 Lab 03-A 與 Lab 03-B 使用。

沒有安裝 Windows 服務。Runner 是手動啟動的程序，電腦重新開機後需要再次啟動。

## 啟動

先確認 GitHub Settings → Actions → Runners 的狀態。若已是 Idle 或 Active，不要重複啟動。離線時，在 PowerShell 執行：

```powershell
$env:PATH = 'C:\Program Files\Git\bin;C:\Program Files\Git\usr\bin;' + $env:PATH
Set-Location -LiteralPath 'D:\actions-runner-lab06'
.\run.cmd
```

看到 `Listening for Jobs` 後保持視窗開啟。PATH 的設定只影響目前 PowerShell 與其啟動的 Runner，讓 npm 呼叫的 bash 使用 Git Bash。ci.yml 的 run 步驟也明確指定 bash。

各 Job 的 `NPM_CONFIG_CACHE` 指向 Runner 暫存目錄下的 `npm-cache`，避免上傳使用者其他專案累積的 npm 共用快取。仍由 setup-node 保存與還原快取。

## 執行實作

- Lab 03-A：建立 PR 或在 Actions → PR CI → Run workflow 手動執行；確認 lint、test (22)、test (24)、build 與測試報告、dist Artifact。
- Lab 03-B：從最新 main 建立除錯分支，四種錯誤與修正均透過 PR 驗證；測試失敗時確認失敗摘要及報告。
- 只有一台 Runner，所以 Node 22 與 24 的 Matrix Job 依序執行。
- Runner 關閉或電腦離線時，CI 會等待 Runner；必要檢查尚未完成時無法合併 PR。

公開 Repository 的外部 PR 設定為 `all_external_contributors`，全部需要人工核准。請先審查程式碼，再核准外部 PR 執行。

## 暫停

前景執行的 Runner 可在視窗按 Ctrl+C，等待目前 Job 結束後停止，保留資料夾及註冊。

若由隱藏視窗啟動，先確認 GitHub Runner 不在執行 Job，再於 PowerShell 停止本次專用目錄的 Listener：

```powershell
Get-CimInstance Win32_Process -Filter "Name='Runner.Listener.exe'" |
  Where-Object { $_.ExecutablePath -eq 'D:\actions-runner-lab06\bin\Runner.Listener.exe' } |
  ForEach-Object { Stop-Process -Id $_.ProcessId }
```

## 最後清理

目前先保留 Runner，不執行 Lab 06 步驟 9 的刪除。等 Lab 03-A、03-B 練習結束且不再使用時，先停止程序，再依 GitHub Runners 頁面的移除指令解除註冊；解除註冊後才刪除專用資料夾。

原先私有的 `runner-lab` 保留 Lab 06 兩輪成功的歷史紀錄，此次 Runner 改註冊於 `devops-lab`。
