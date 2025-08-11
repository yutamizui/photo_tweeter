# README

## ローカル実行手順

### 前提
- Ruby 3.3.0
- Rails 8.0.2
- PostgreSQL（ローカル動作用）
- macOS (arm64)

### 初回セットアップ
# Ruby を合わせる
rbenv local 3.3.0 || true

# 依存関係インストール
bundle install

# DB 作成＆マイグレーション
bin/rails db:prepare

# 開発用データ投入（任意）
bin/rails db:seed

# サーバ起動
bin/rails s
# http://localhost:3000 へアクセス
