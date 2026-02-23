# CORS設定：フロントエンド（Next.js）からのリクエストを許可する
# credentials: true にすることで、Cookieを使った認証（devise_token_auth）が動く

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # NEXT_PUBLIC_FRONT_URL に設定したURLからのアクセスのみ許可
    # 開発時 → http://localhost:3001
    # 本番時 → https://あなたのドメイン.com
    origins ENV.fetch("FRONTEND_URL", "http://localhost:3001")

    resource "*",
      headers: :any,
      # devise_token_auth の認証ヘッダをフロントに公開する（必須）
      expose: ["access-token", "expiry", "token-type", "uid", "client"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true   # Cookieを送受信するために必須
  end
end
