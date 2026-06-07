---
name: create-pr
description: gh コマンドで GitHub プルリクエストを作成するときに使う。
---

# Create PR

以下の手順で、GitHub のプルリクエストを作成する。

## 目的

`gh pr create` を使い、指定ブランチまたは現在のブランチから `main` への PR を作成する。

## 前提

- ユーザーが「PRを作成」「プルリクエストを作成」「$create-pr」など、PR 作成を明示的に依頼したときにのみ使う。
- `gh` コマンドが使用可能であること。
- PR 作成前に作業ツリーの状態を確認する。
- 作業ツリーに未コミットの変更がある場合は、PR 作成前にユーザーへ確認する。

## ブランチ決定

```bash
git branch --show-current
git status --short --branch
```

1. ユーザーがブランチを指定している場合は、そのブランチを head にする。
2. ブランチ指定がない場合は、現在のブランチを head にする。
3. head が `main` の場合は、PR 作成前にユーザーへ確認する。

## PR 内容

- PR タイトルは日本語で分かりやすく書く。
- PR 説明文は以下のフォーマットで記載する。

```markdown
## 目的
- PRのゴール

## 概要
- 変更したファイルと、その変更内容、変更意図を簡単に記載

## 補足(任意)
- 利用方法など、あれば記載
```

## 実行コマンド

```bash
git push -u origin HEAD

gh pr create \
  --title "PRのタイトル" \
  --body "PRの説明文" \
  --base main \
  --head <head-branch>
```

## 完了確認

PR 作成後、`gh pr create` の出力に含まれる PR URL をユーザーへ伝える。
