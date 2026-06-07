# pnpm workspace 共通パッケージ層 (`/apps/config`, `/apps/packages`, `/apps/`)

```text
/apps
├── config/
│   ├── env/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── schemas.ts
│   ├── eslint/
│   │   └── base.config.js
│   ├── typescript/
│   │   ├── base.json
│   │   ├── nextjs.json
│   │   └── node.json
│   ├── package.json
│   └── README.md
├── packages/
│   ├── types/
│   │   ├── src/
│   │   │   ├── api/
│   │   │   │   └── users.ts
│   │   │   ├── domain/
│   │   │   │   └── user.ts
│   │   │   └── index.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── utils/
│   │   ├── src/
│   │   │   ├── date.ts
│   │   │   ├── object.ts
│   │   │   └── index.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── db/
│   │   ├── prisma/
│   │   │   ├── migrations/
│   │   │   └── schema.prisma
│   │   ├── src/
│   │   │   ├── client.ts
│   │   │   └── index.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── logger/
│       ├── src/
│       │   ├── create-logger.ts
│       │   └── index.ts
│       ├── package.json
│       └── tsconfig.json
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
└── turbo.json
```

- **`/apps/config`**: ワークスペース全体で共有する設定パッケージを配置します。環境変数スキーマ、ESLint 設定、TypeScript 設定など、各アプリが同じルールを参照するための基盤です。
- **`/apps/config/env`**: クライアント公開可能な環境変数とサーバー専用の環境変数を分離して定義します。Zod などで検証し、起動時の設定漏れを早期に検出します。
- **`/apps/config/eslint`**: Web、API、共通パッケージで使う ESLint のベース設定を配置します。各アプリは必要な差分だけ上書きします。
- **`/apps/config/typescript`**: `base`、`nextjs`、`node` など用途別の `tsconfig` を配置します。型チェックの方針を一元化し、設定重複を避けます。
- **`/apps/packages`**: アプリケーション間で共有するライブラリを配置します。各パッケージは独立した `package.json` を持ち、Turborepo の依存グラフに乗せます。
- **`/apps/packages/types`**: API 契約、ドメイン型、DTO など共有型を配置します。Web と API の型ずれを防ぎ、境界で使うデータ構造を明示します。
- **`/apps/packages/types/src/api`**: HTTP API の request/response 型を配置します。OpenAPI や schema 生成と連携させる場合もこの責務に寄せます。
- **`/apps/packages/types/src/domain`**: User、Organization、Task など、アプリ全体で意味が共有されるドメイン型を配置します。
- **`/apps/packages/utils`**: 日付、オブジェクト操作、文字列処理など、ドメイン非依存の小さなユーティリティを配置します。肥大化を避けるため、業務ロジックは置きません。
- **`/apps/packages/db`**: Prisma schema、migration、Prisma Client の生成と公開を担います。DB モデルを API や他パッケージから直接ばらばらに管理しないための境界です。
- **`/apps/packages/db/prisma`**: `schema.prisma` と migrations を配置します。DB スキーマ変更はこのパッケージで管理し、生成物は `src/client.ts` から公開します。
- **`/apps/packages/logger`**: Web、API、worker 連携ログなどで共通利用できるロガー生成処理を配置します。出力形式、ログレベル、トレース ID の扱いを統一します。
- **`/apps/package.json`**: pnpm workspace のルート package として、Turborepo コマンド、共通 devDependencies、ワークスペース全体の scripts を定義します。
- **`/apps/pnpm-workspace.yaml`**: `web`、`api`、`config`、`packages/*` を workspace として登録します。catalog を使う場合は依存バージョンもここで統制します。
- **`/apps/turbo.json`**: build、lint、test、typecheck などのタスク依存関係とキャッシュポリシーを定義します。モノレポ内の変更範囲に応じた効率的な実行を実現します。
