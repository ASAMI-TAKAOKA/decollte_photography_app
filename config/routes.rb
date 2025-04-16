Rails.application.routes.draw do
  root to: "brands#index"

  # 管理者用ルーティング
  namespace :admin do
    resource :session, only: %i[ new create destroy ] # ログイン・ログアウト用
    resources :admin_users
    root to: 'dashboards#show'

    # ブランド・店舗管理
    resources :brands do
      resources :stores do
        resource :position, only: %i[ update ], module: :stores
      end
    end

    # ブランドに紐づかない店舗一覧
    resources :stores, only: %i[ index ] do
      resource :position, only: %i[ update ], module: :stores
    end
  end

  # 一般ユーザー向けのブランド一覧、ブランド詳細
  resources :brands, only: %i[ index show ]

  # 一般ユーザー向けの店舗一覧
  resources :stores, only: %i[ index ]
end
