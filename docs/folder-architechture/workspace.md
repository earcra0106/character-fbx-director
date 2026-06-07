# フォルダ詳細構成・設計書

本書は、本プロジェクトにおけるワークスペース全体の詳細なディレクトリ構造と、それぞれのフォルダが持つ責務について定義します。

## 1. ワークスペース全体（ルート階層）

```text
/workspace
├── .devcontainer/
│   ├── devcontainer.json
│   └── docker-compose.yml
├── .docker/
│   ├── api/
│   │   └── Dockerfile
│   ├── web/
│   │   └── Dockerfile
│   └── worker/
│       └── Dockerfile
├── .codex/
│   ├── rules/
│   └── skills/
├── docs/
├── apps/
│   ├── api/
│   ├── web/
│   ├── config/
│   ├── packages/
│   ├── package.json
│   ├── pnpm-lock.yaml
│   ├── pnpm-workspace.yaml
│   └── turbo.json
├── worker/
│   ├── app/
│   ├── tests/
│   ├── pyproject.toml
│   └── uv.lock
├── .gitignore
├── AGENTS.md
├── docker-compose.yml
└── README.md
```

- **`.devcontainer`**: devcontainer 起動用の設定を配置します。Node/pnpm を使う `apps` と Python/uv を使う `worker` を同一開発環境で扱うため、サービス定義、マウント、ポート、初期化コマンドを集約します。
- **`.docker`**: 各実行単位の Dockerfile を配置します。`web`、`api`、`worker` のランタイム差分を分離し、ビルドキャッシュや本番向けイメージ設計を個別に最適化できるようにします。
- **`.codex`**: Codex 向けのルール、スキル、作業補助ファイルを配置します。アプリケーションコードとは分離し、開発支援の変更が実装レイヤーへ混ざらないようにします。
- **`docs`**: プロジェクト構成、設計判断、運用手順、アーキテクチャ文書を管理します。実装者がディレクトリ責務や開発環境を確認するための一次情報を置きます。
- **`docs/architecture`**: システム構成、フォルダ設計、依存関係、境界設計などの長期的に参照する設計文書を配置します。
- **`apps`**: pnpm workspace と Turborepo で管理する TypeScript 系モノレポ領域です。Next.js の Web、Fastify の API、共通設定、共有パッケージを含めます。
- **`worker`**: FastAPI による非同期処理、重いタスク、外部 API 連携、バックグラウンドジョブを実行する Python サービスです。Node 側とは責務を分離し、uv で依存管理します。
- **`.gitignore`**: `node_modules`、`.next`、`dist`、`.venv`、キャッシュ、ログ、環境変数ファイルなど、リポジトリ管理対象外のファイルを定義します。
- **`docker-compose.yml`**: ローカル開発や統合検証で `web`、`api`、`worker`、DB、キューなどをまとめて起動するためのルート compose ファイルです。
- **`AGENTS.md`**: エージェント作業時のプロジェクト固有ルールを定義します。
- **`README.md`**: セットアップ、起動方法、主要コマンド、プロジェクト概要をまとめる入口ドキュメントです。

---

## 2. 各領域の詳細
詳細はそれぞれ以下のドキュメントを参照してください。

- apps : [pnpm workspace 共通パッケージ層](docs/folder-architechture/apps.md)
  - web : [Next.js Web アプリケーション](docs/folder-architechture/web.md)
  - api : [Fastify API サービス](docs/folder-architechture/api.md)
- worker : [タスク実行ワーカー層](docs/folder-architechture/worker.md)

## 3. 実行プロセス

1. ルートの `compose.yaml` または devcontainer で、`web`、`api`、`worker`、DB、キューなどの開発サービスを起動します。
2. TypeScript 系は `/apps` を pnpm workspace のルートとして扱い、`pnpm --filter @repo/web dev`、`pnpm --filter @repo/api dev` のようにサービス単位で実行します。
3. Turborepo では `build`、`lint`、`test`、`typecheck` をタスクとして定義し、変更された package と依存先だけを効率的に検証します。
4. Python worker は `/worker` を uv 管理の独立サービスとして扱い、`uv run uvicorn app.main:app --reload` のように起動します。
5. DB schema と Prisma Client は `/apps/packages/db` に集約し、API からは package import 経由で利用します。
6. 環境変数は `/apps/config/env` と `/worker/app/core/config.py` で検証し、クライアント公開可能な値とサーバー専用の値を明確に分離します。
7. 新機能を追加する場合は、Web は `src/features/<feature>`、API は `src/routes/<resource>` と `src/services`、worker は `app/tasks/definitions` と `app/services` を中心に変更し、責務が混ざらないようにします。
