# タスク実行ワーカー層 (`/worker`)

```text
/worker
├── app/
│   ├── main.py
│   ├── api/
│   │   ├── routes/
│   │   │   ├── health.py
│   │   │   └── jobs.py
│   │   └── dependencies.py
│   ├── core/
│   │   ├── config.py
│   │   ├── logging.py
│   │   └── security.py
│   ├── tasks/
│   │   ├── definitions/
│   │   │   ├── image_processing.py
│   │   │   └── report_generation.py
│   │   ├── queue.py
│   │   ├── scheduler.py
│   │   └── runner.py
│   ├── services/
│   │   ├── job_service.py
│   │   └── notification_service.py
│   ├── integrations/
│   │   ├── external_api/
│   │   │   ├── client.py
│   │   │   └── schemas.py
│   │   └── storage/
│   │       ├── client.py
│   │       └── paths.py
│   ├── repositories/
│   │   └── job_repository.py
│   ├── schemas/
│   │   ├── job.py
│   │   └── health.py
│   └── utils/
│       ├── retry.py
│       └── time.py
├── tests/
│   ├── integration/
│   │   └── test_jobs_api.py
│   └── unit/
│       ├── test_job_service.py
│       └── test_tasks.py
├── pyproject.toml
├── README.md
└── uv.lock
```

- **`/app/main.py`**: FastAPI アプリケーションの生成、router 登録、ミドルウェア設定を行うエントリーポイントです。
- **`/app/api`**: worker の HTTP インターフェースを配置します。ジョブ投入、状態確認、ヘルスチェックなど、外部から呼び出される API を管理します。
- **`/app/api/routes`**: FastAPI の router を機能別に配置します。各 route はリクエスト検証と service 呼び出しに集中し、重い処理は `tasks` や `services` へ委譲します。
- **`/app/api/dependencies.py`**: FastAPI の Depends で使う依存注入を定義します。設定、認証、DB セッション、外部クライアントなどを route から切り離します。
- **`/app/core`**: worker 全体の基盤設定を配置します。環境変数、ロギング、セキュリティ、起動時初期化など、横断的に使う処理をまとめます。
- **`/app/tasks`**: 非同期または重いタスクの定義、実行、スケジューリング、キュー接続を配置します。API 層と実処理を分離し、将来的に Celery、RQ、Arq、独自キューへ移行しやすくします。
- **`/app/tasks/definitions`**: 画像処理、レポート生成、外部同期など、個別タスクの実装を配置します。入出力の型と副作用を明確にし、タスク単位でテストできるようにします。
- **`/app/tasks/queue.py`**: キューへの enqueue/dequeue、ジョブ ID 発行、優先度設定などを扱います。キュー実装の詳細を service から隠します。
- **`/app/tasks/scheduler.py`**: 定期実行や遅延実行のスケジュール定義を配置します。cron 的な処理を route や service へ混在させないための場所です。
- **`/app/tasks/runner.py`**: タスク実行の共通制御を配置します。リトライ、タイムアウト、ログ、失敗時通知など、各タスクに共通する実行ルールを扱います。
- **`/app/services`**: worker 内のユースケースを配置します。ジョブ作成、進捗更新、通知、成果物保存など、タスクと repository、外部連携を調整します。
- **`/app/integrations`**: 外部 API、ストレージ、メッセージング、LLM などの外部システム連携を配置します。クライアント、認証、リクエスト/レスポンス schema を分離します。
- **`/app/repositories`**: DB や永続化ストアへのアクセスを抽象化します。ジョブ状態や成果物メタデータの読み書きを service から分離します。
- **`/app/schemas`**: Pydantic モデルを配置します。API 入出力、タスク入力、ジョブ状態などの検証可能なデータ構造を定義します。
- **`/app/utils`**: リトライ、時刻処理、軽量なヘルパーなど、worker 内で再利用する汎用処理を配置します。業務判断を含む処理は `services` に置きます。
- **`/tests`**: worker の unit/integration テストを配置します。タスク定義、service、API route、外部連携の mock を分けて検証します。
- **`/pyproject.toml`**: Python パッケージ定義、依存関係、pytest、ruff、mypy などの設定を管理します。
- **`/uv.lock`**: uv によって解決された依存関係を固定します。再現性のある worker 環境を維持するために管理します。
