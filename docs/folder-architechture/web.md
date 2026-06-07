# Webアプリケーション層 (`/apps/web`)

```text
/apps/web
├── public/
│   ├── images/
│   └── favicon.ico
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   └── layout.tsx
│   │   ├── (dashboard)/
│   │   │   ├── dashboard/
│   │   │   │   ├── page.tsx
│   │   │   │   └── loading.tsx
│   │   │   └── layout.tsx
│   │   ├── api/
│   │   │   └── health/
│   │   │       └── route.ts
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   ├── not-found.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── ui/
│   │   │   ├── button.tsx
│   │   │   └── dialog.tsx
│   │   ├── layout/
│   │   │   ├── app-header.tsx
│   │   │   └── sidebar.tsx
│   │   └── feedback/
│   │       ├── error-message.tsx
│   │       └── loading-indicator.tsx
│   ├── features/
│   │   ├── auth/
│   │   │   ├── components/
│   │   │   │   └── login-form.tsx
│   │   │   ├── hooks/
│   │   │   │   └── use-login.ts
│   │   │   ├── services/
│   │   │   │   └── auth-client.ts
│   │   │   ├── schemas/
│   │   │   │   └── login-schema.ts
│   │   │   └── types.ts
│   │   └── dashboard/
│   │       ├── components/
│   │       ├── hooks/
│   │       ├── services/
│   │       └── types.ts
│   ├── lib/
│   │   ├── api/
│   │   │   ├── client.ts
│   │   │   └── errors.ts
│   │   ├── env.ts
│   │   ├── logger.ts
│   │   └── utils.ts
│   ├── providers/
│   │   ├── app-provider.tsx
│   │   └── query-provider.tsx
│   ├── styles/
│   │   └── tokens.css
│   └── types/
│       ├── global.d.ts
│       └── next-auth.d.ts
├── tests/
│   ├── e2e/
│   │   └── auth.spec.ts
│   └── unit/
│       └── components/
├── next.config.ts
├── package.json
├── postcss.config.js
├── tailwind.config.ts
└── tsconfig.json
```

- **`/public`**: 静的ファイルを配置します。画像、favicon、OGP 画像など、ビルド処理を通さず配信するアセットを管理します。
- **`/src/app`**: Next.js App Router のルート、レイアウト、ページ、Route Handler を配置します。URL 構造とレンダリング境界を表現する場所であり、機能ロジックはできるだけ `features` や `lib` に委譲します。
- **`/src/app/(auth)`**: 認証関連画面をルートグループとしてまとめます。URL に影響しない UI 境界を作り、ログイン前後のレイアウトを分離します。
- **`/src/app/(dashboard)`**: 認証後の業務画面をまとめます。共通サイドバーやヘッダーを持つダッシュボード系レイアウトを閉じ込めます。
- **`/src/app/api`**: Next.js 側で必要な軽量 Route Handler を配置します。基本的な業務 API は `apps/api` に置き、ここにはヘルスチェック、Webhook 受信補助、BFF 的な薄い処理のみを置きます。
- **`/src/components`**: 複数機能で再利用する UI コンポーネントを配置します。業務ドメイン固有の状態や API 呼び出しは持たせず、見た目と基本的な振る舞いに責務を限定します。
- **`/src/components/ui`**: Button、Dialog、Input などのプリミティブ UI を配置します。デザインシステムの基礎となるため、依存先は最小限にします。
- **`/src/components/layout`**: アプリケーション全体で使うヘッダー、ナビゲーション、サイドバーなどの構造コンポーネントを配置します。
- **`/src/features`**: 認証、ダッシュボード、設定などの機能単位で UI、hooks、サービス、スキーマ、型をカプセル化します。機能ごとの変更範囲を閉じ、スケール時の見通しを保つために導入します。
- **`/src/features/*/components`**: その機能でのみ使う画面部品を配置します。共有化が必要になった場合だけ `src/components` へ昇格します。
- **`/src/features/*/hooks`**: その機能固有の React hooks を配置します。フォーム状態、クエリ状態、UI 状態などを機能内に閉じます。
- **`/src/features/*/services`**: API クライアント呼び出しやユースケース寄りの処理を配置します。UI から通信処理を分離し、テストしやすくします。
- **`/src/features/*/schemas`**: Zod などによるフォーム入力、検索条件、API レスポンスの検証スキーマを配置します。
- **`/src/lib`**: アプリ全体で使う非 UI の基盤処理を配置します。API クライアント、環境変数、ロガー、日付処理、汎用ユーティリティなどを管理します。
- **`/src/providers`**: React Context、Query Client、認証セッションなど、アプリ全体へ注入する provider を配置します。
- **`/src/styles`**: Tailwind の拡張、CSS 変数、デザイントークンなど、グローバルなスタイル定義を配置します。
- **`/src/types`**: Next.js や外部ライブラリ拡張を含む、Web アプリ固有の型定義を配置します。共通型は `apps/packages/types` に置きます。
- **`/tests`**: Web 層のユニットテスト、コンポーネントテスト、E2E テストを配置します。ユーザー操作やページ遷移の検証をアプリ単位で管理します。
