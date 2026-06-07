---
name: finish-work
description: 作業完了後に main ブランチへ戻して最新化するときに使う。
---

# Finish Work

以下のコマンドを実行して、`main` ブランチを最新の状態に更新する。

```bash
git branch --show-current
git checkout main
git pull origin main
```
