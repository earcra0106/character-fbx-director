# DevContainer Overview

## 概要

`echo $REMOTE_CONTAINERS` の出力が `true` の場合、この環境はdevcontainerです。

## コンテナ構成

このプロジェクトは、 node/pnpm で構築された web/api セクションと、 python で構築された worker セクションで構成されています。

```
project
├── api - Fastify + TypeScript 
├── web - Next.js + React + Tailwind CSS + TypeScript
└── worker - FastAPI + uvicorn + Python
```

## コマンド実行について

devcontainer 内には node と python がインストールされています。
パッケージマネージャーは pnpm と uv です。
実装の際、既存のパッケージで解決できる要件は、コードを自作するのではなく優先的にパッケージを取り入れてください。

## pnpm 運用について
web と api アプリは、 pnpm workspace と turborepo で管理されています。
古いバージョンがインストールされるのを防ぐため、新しいパッケージをインストールする際は `pnpm add` を使用してください。
`pnpm install` は、パッケージが解決できないなどの不具合の際に実行してください。
モノレポでturboを使って管理し、個別のパッケージにインストールしたい場合は `pnpm --filter @repo/<web|api> add <package-name>` を使用してください。

```bash
cd /workspaces/apps && pnpm add <package-name>
```

## uv 運用について
worker コンテナでは、uv を使用して Python の依存関係を管理しています。
古いバージョンがインストールされるのを防ぐため、新しいライブラリをインストールする際は `uv add` を使用してください。
`uv sync` は、ライブラリが解決できないなどの不具合の際に実行してください。
なお、 **PyTorch** のような重いパッケージ、または速度が予測できないパッケージをインストールしたい場合、直接インストールせず、ユーザにインストールを依頼してください。
