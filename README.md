# Project Devcontainer Template

他プロジェクトへコピーして使うための開発環境テンプレートです。

## 使い方

1. このリポジトリをテンプレートとしてリポジトリを作成する。
2. 必要に応じて各 `Dockerfile` に使用言語やツールを追加する。
3. Dev Containers でプロジェクトを開く。

## 引き継ぐホスト設定

`gh` 、 `codex` の認証情報はそのまま引き継がれます。
SSH_AUTH_SOCK がホストで設定されている場合、SSH鍵としてgitの認証に利用します。
