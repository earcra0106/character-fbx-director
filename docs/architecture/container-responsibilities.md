# コンテナ責務・利用ライブラリ設計

## 1. 全体方針

本プロジェクトは、devcontainer 資料で定義されている `web`、`api`、`worker` の 3 領域を中心に構成する。

- `web`: 制作者が操作する Next.js アプリケーション
- `api`: プロジェクト、ジョブ、ファイル、認証、永続化を扱う Fastify API
- `worker`: FBX 解析、モーション補正、成果物生成を扱う Python サービス

Web/API は `/apps` 配下の pnpm workspace と Turborepo で管理し、worker は `/worker` 配下で uv により管理する。モーション補正は計算量が大きく、外部ライブラリ依存も増えやすいため、Node.js の API から分離して worker に集約する。

## 2. コンテナ間の責務分担

```text
user
  |
  v
web container
  |  HTTP/JSON
  v
api container
  |  job request / status sync
  v
worker container
  |
  v
storage / database / generated artifacts
```

### 2.1 web コンテナ

#### 役割

- プロジェクト一覧、詳細、モーション調整画面を提供する
- FBX ファイルのアップロード導線を提供する
- 武器パラメータ、キャラクター属性、補正プリセットを入力する UI を提供する
- 補正前後の 3D プレビューを表示する
- ジョブ進捗、失敗理由、成果物ダウンロードを表示する

#### 主な機能

- ダッシュボード
- プロジェクト作成・編集
- モーションファイル登録
- 武器・キャラクター設定フォーム
- 3D モーションビューア
- 補正ジョブ実行ボタン
- ジョブ履歴と成果物一覧

#### 推奨ライブラリ

- `next`: App Router による Web アプリケーション基盤
- `react`: UI 構築
- `typescript`: 型安全な UI 実装
- `tailwindcss`: 画面スタイル
- `three`: 3D モーションプレビュー
- `@react-three/fiber`: React から Three.js を扱うための基盤
- `@react-three/drei`: カメラ、コントロール、ローダーなどの補助
- `@tanstack/react-query`: API データ取得、ジョブ進捗ポーリング、キャッシュ管理
- `react-hook-form`: パラメータ入力フォーム
- `zod`: フォーム入力と API レスポンス検証
- `lucide-react`: UI アイコン

#### 実装配置

- `/apps/web/src/app/(dashboard)`: ダッシュボードとプロジェクト画面
- `/apps/web/src/features/projects`: プロジェクト管理
- `/apps/web/src/features/motions`: モーション登録、プレビュー、補正操作
- `/apps/web/src/features/jobs`: ジョブ進捗と履歴
- `/apps/web/src/lib/api`: API クライアント
- `/apps/web/src/components/ui`: 共通 UI

### 2.2 api コンテナ

#### 役割

- Web からの HTTP API を受け付ける
- プロジェクト、入力ファイル、補正パラメータ、ジョブ状態、成果物メタデータを管理する
- worker へ補正ジョブを依頼する
- ジョブ状態と成果物 URL を Web へ返す
- 認証・認可、入力検証、監査ログを担う

#### 主な機能

- プロジェクト CRUD
- モーションファイル登録とアップロード URL 発行
- 武器パラメータ管理
- キャラクター属性管理
- 補正ジョブ作成
- ジョブ状態取得
- 成果物一覧取得
- worker との連携 API

#### 推奨ライブラリ

- `fastify`: HTTP API サーバー
- `typescript`: 型安全な API 実装
- `zod` または `@sinclair/typebox`: request/response schema
- `@fastify/cors`: CORS 制御
- `@fastify/jwt`: 認証トークン検証
- `@fastify/multipart`: FBX などのファイルアップロード受け口
- `@fastify/swagger`、`@fastify/swagger-ui`: API 仕様の生成と確認
- `prisma`: DB schema と永続化
- `pino`: Fastify と連携するロギング
- `undici`: worker や外部サービスへの HTTP クライアント

#### 実装配置

- `/apps/api/src/routes/projects`: プロジェクト API
- `/apps/api/src/routes/motions`: 入力モーション API
- `/apps/api/src/routes/weapons`: 武器設定 API
- `/apps/api/src/routes/characters`: キャラクター設定 API
- `/apps/api/src/routes/jobs`: 補正ジョブ API
- `/apps/api/src/services`: ユースケース
- `/apps/api/src/repositories`: DB アクセス
- `/apps/api/src/plugins`: CORS、JWT、Prisma、Swagger
- `/apps/packages/types`: Web と API で共有する契約型
- `/apps/packages/db`: Prisma schema と Prisma Client

### 2.3 worker コンテナ

#### 役割

- API から依頼された補正ジョブを受け付ける
- FBX モーションを解析する
- 武器パラメータとキャラクター属性をもとに補正・誇張を行う
- 補正済み FBX と差分レポートを生成する
- ジョブ進捗と失敗理由を API へ返す

#### 主な機能

- ジョブ受付
- 入力ファイル取得
- FBX 解析
- ボーン階層とキーフレーム抽出
- 武器パラメータに基づく慣性・重心補正
- キャラクター属性に基づくタイミング補正
- ゲーム向け誇張処理
- 出力ファイル生成
- 差分レポート生成

#### 推奨ライブラリ

- `fastapi`: worker の HTTP インターフェース
- `uvicorn`: FastAPI 起動
- `pydantic`: API 入出力、ジョブ設定、補正パラメータの検証
- `numpy`: 時系列データ、ベクトル、回転値の数値計算
- `scipy`: 補間、スムージング、回転表現の処理
- `trimesh`: 3D データ処理の補助
- `pyassimp` または `fbx` SDK 系ライブラリ: FBX 読み書き
- `redis`、`rq`、または `arq`: 非同期ジョブキュー
- `httpx`: API への状態通知、ストレージ連携
- `pytest`: unit/integration テスト
- `ruff`: Python lint/format

FBX ライブラリは環境構築難度が高い可能性があるため、初期検証では `pyassimp`、Blender CLI、Autodesk FBX SDK のいずれが devcontainer と本番環境で安定するかを比較してから採用する。重い機械学習系ライブラリや PyTorch は、devcontainer 資料の方針に従い、必要性が確定するまで直接追加しない。

#### 実装配置

- `/worker/app/api/routes/jobs.py`: ジョブ受付と状態確認
- `/worker/app/services/job_service.py`: ジョブ実行のユースケース
- `/worker/app/services/motion_analysis_service.py`: FBX 解析
- `/worker/app/services/motion_correction_service.py`: 補正・強調処理
- `/worker/app/tasks/definitions/motion_correction.py`: 補正ジョブ本体
- `/worker/app/integrations/storage`: 入力・出力ファイルの取得と保存
- `/worker/app/schemas/job.py`: ジョブ入力・出力 schema
- `/worker/tests`: 補正ロジックと API のテスト

## 3. 共有パッケージ

### 3.1 `/apps/packages/types`

Web と API の境界で使う型を配置する。

- `Project`
- `MotionAsset`
- `WeaponProfile`
- `CharacterProfile`
- `CorrectionPreset`
- `CorrectionJob`
- `Artifact`

API の request/response 型もここに置き、Web 側の手書き型定義とずれないようにする。

### 3.2 `/apps/packages/db`

Prisma schema と Prisma Client を管理する。初期候補の主要モデルは以下とする。

- `User`
- `Project`
- `MotionAsset`
- `WeaponProfile`
- `CharacterProfile`
- `CorrectionPreset`
- `CorrectionJob`
- `Artifact`

### 3.3 `/apps/packages/logger`

Web、API、worker 連携で利用するトレース ID、ジョブ ID、プロジェクト ID をログに含めるための共通ロギング方針を定義する。

## 4. データフロー

### 4.1 モーション登録

1. ユーザーが Web から FBX を登録する
2. Web が API へアップロード要求を送る
3. API が入力ファイルのメタデータを保存する
4. API が保存先またはアップロード URL を返す
5. Web が登録完了後にプロジェクト詳細を更新する

### 4.2 補正ジョブ実行

1. ユーザーが Web で武器・キャラクター・プリセットを設定する
2. Web が API へ補正ジョブ作成を要求する
3. API がジョブを `queued` として保存する
4. API が worker へジョブを依頼する
5. worker が入力ファイルを取得し、補正処理を実行する
6. worker が進捗と結果を API へ通知する
7. API が成果物メタデータを保存する
8. Web がジョブ状態を取得し、成果物を表示する

### 4.3 プレビュー

1. Web が API から補正前後の成果物 URL を取得する
2. Web が Three.js ビューアでモーションを読み込む
3. ユーザーが再生、停止、フレーム送り、補正前後比較を行う

## 5. 初期採用しないもの

- 本格的な動画姿勢推定
- 大規模な機械学習モデル
- チームコラボレーション機能
- DCC ツール内プラグイン
- Unity/Unreal Engine への直接エクスポート

これらは研究検証の中核である「武器・キャラクター属性に基づくモーション補正」が動作した後に追加する。

## 6. 検証方針

### 6.1 web

- 型チェック
- lint
- 主要画面のコンポーネントテスト
- 3D プレビューはサンプルファイルで読み込み確認

### 6.2 api

- route schema の unit test
- service の unit test
- プロジェクト作成、ジョブ作成、状態取得の integration test
- worker mock を使ったジョブ連携テスト

### 6.3 worker

- FBX 解析の fixture test
- 補正パラメータによる時系列変化の unit test
- ジョブ受付と状態更新の integration test
- 失敗時のリトライ、タイムアウト、エラーメッセージ検証
