# バックエンドAPI層 (`/apps/api`)

```text
/apps/api
├── src/
│   ├── app.ts
│   ├── server.ts
│   ├── config/
│   │   ├── env.ts
│   │   └── server-config.ts
│   ├── plugins/
│   │   ├── cors.ts
│   │   ├── jwt.ts
│   │   ├── prisma.ts
│   │   └── sensible.ts
│   ├── routes/
│   │   ├── index.ts
│   │   ├── health/
│   │   │   ├── health.controller.ts
│   │   │   ├── health.routes.ts
│   │   │   └── health.schema.ts
│   │   └── users/
│   │       ├── users.controller.ts
│   │       ├── users.routes.ts
│   │       └── users.schema.ts
│   ├── controllers/
│   │   └── base-controller.ts
│   ├── services/
│   │   ├── auth.service.ts
│   │   └── users.service.ts
│   ├── repositories/
│   │   └── users.repository.ts
│   ├── schemas/
│   │   ├── error.schema.ts
│   │   └── pagination.schema.ts
│   ├── hooks/
│   │   ├── auth-hook.ts
│   │   └── request-context-hook.ts
│   ├── lib/
│   │   ├── errors.ts
│   │   ├── logger.ts
│   │   └── response.ts
│   └── types/
│       ├── fastify.d.ts
│       └── request-context.ts
├── tests/
│   ├── integration/
│   │   └── users.routes.test.ts
│   └── unit/
│       └── users.service.test.ts
├── package.json
└── tsconfig.json
```

- **`/src/app.ts`**: Fastify インスタンスの生成、プラグイン登録、ルート登録を行います。テストからも import しやすいよう、listen 処理は `server.ts` に分離します。
- **`/src/server.ts`**: 実際に HTTP サーバーを起動するエントリーポイントです。環境変数を読み込み、ポートやホストを決定します。
- **`/src/config`**: API サーバー固有の設定を配置します。共通環境変数定義は `apps/config` を参照し、この層では Fastify 起動に必要な設定へ変換します。
- **`/src/plugins`**: Fastify plugin を配置します。CORS、JWT、Prisma、ロギング、エラーハンドリングなど、アプリ全体に差し込む横断的な機能を管理します。
- **`/src/routes`**: HTTP ルート定義を配置します。バージョニングやドメイン単位でディレクトリを分け、各 route ファイルは controller と schema を結び付ける薄い責務にします。
- **`/src/routes/*/*.controller.ts`**: リクエストから入力を取り出し、service を呼び出し、HTTP レスポンスへ変換します。業務ロジックは持たせません。
- **`/src/routes/*/*.schema.ts`**: Fastify の request/response schema を配置します。OpenAPI 生成や入力検証に使えるよう、ルートに近い場所で契約を定義します。
- **`/src/controllers`**: 複数 route で共通化する controller 基盤やレスポンス変換を配置します。機能固有 controller は原則として `routes` 配下に置きます。
- **`/src/services`**: ユースケースと業務ロジックを配置します。controller、repository、外部クライアントの間を調整し、トランザクションや権限判断などの中核処理を担います。
- **`/src/repositories`**: DB アクセスを抽象化します。Prisma Client への直接依存を閉じ込め、service が永続化の詳細を意識しないようにします。
- **`/src/schemas`**: ページネーション、エラー、共通レスポンスなど、複数 route で使う schema を配置します。
- **`/src/hooks`**: Fastify hook を配置します。認証、認可、リクエストコンテキスト、監査ログなど、リクエストライフサイクルに関わる処理を管理します。
- **`/src/lib`**: API 層で使う共通処理を配置します。エラー型、ロガー、レスポンス整形、外部サービスの薄いクライアントなどを管理します。
- **`/src/types`**: Fastify の型拡張、リクエストコンテキスト、API 層固有の型を配置します。フロントや worker と共有すべき契約型は `apps/packages/types` に置きます。
- **`/tests`**: API 層の unit/integration テストを配置します。service 単体、route の HTTP 契約、plugin 登録、DB 連携を分けて検証します。
