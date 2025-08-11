# README

## ローカル実行手順

### 前提
- Ruby 3.3.0
- Rails 8.0.2
- PostgreSQL（ローカル動作用）
- macOS (arm64)

### 初回セットアップ
```bash
# Ruby を合わせる（rbenv/asdf を使っている場合）
rbenv local 3.3.0 || true

# 依存関係インストール
bundle install

# DB 作成＆マイグレーション
bin/rails db:prepare

# 開発用データ投入（任意）
bin/rails db:seed

# .envファイル
USER_ID=recruit_66297
USER_PASSWORD=password

OAUTH_CLIENT_ID=E5qKUGSSTzThZa6yCx1OVAPDY3BNOPOYgQ6EQaPjnRI
OAUTH_CLIENT_SECRET=W66dCgiQXpx4-0ZwUlU4SdyrYWd62_FtePQ_L5THs8s
OAUTH_REDIRECT_URI=http://localhost:3000/oauth/callback
OAUTH_AUTHORIZE_URL=http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/authorize
OAUTH_TOKEN_URL=http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/token
TWEET_API_URL=http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/api/tweets

# サーバ起動
bin/rails s
# http://localhost:3000 へアクセス
