Rails.application.routes.draw do
  root to: "brands#index"

  # 管理者用ルーティング
  namespace :admin do
    resource :session, only: %i[ new create destroy ] # ログイン・ログアウト用
    resources :admin_users
    resource :dashboards, only: %i[ show ], path: "" # /admin

    # ブランド・店舗管理
    resources :brands, param: :slug do
      resources :stores
    end

    # ブランドに紐づかない店舗一覧
    resources :stores, only: %i[ index update ]
  end

  # 一般ユーザー向けのブランド一覧、ブランド詳細
  resources :brands, only: %i[ index show ], param: :slug

  # 一般ユーザー向けの店舗一覧
  resources :stores, only: %i[ index ]
end
