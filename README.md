# devops-lab

DevOps 課程實作用的範例專案，沒有任何第三方套件。

## 本機執行

有 Node.js 與 npm：

```bash
npm ci
npm run lint
npm run format:check
npm test
npm run build
```

沒有 npm（離線環境）：

```bash
bash scripts/check-all.sh
```
