Rails.application.routes.draw do
  root to: "brands#index"

  # 管理者ログイン関連
  get "admin/login", to: "admin_users#login", as: "admin_users_login"
  post "admin/login", to: "admin_users#login"
  delete "logout", to: "admin_users#logout", as: "admin_users_logout"
  resources :admin_users
  get "admin/dashboard", to: "admin_users#dashboard", as: "admin_dashboard"

  # ブランドと店舗関連
  resources :brands, param: :slug do
    resources :stores, param: :id do
      member do
        get :move_higher_within_brand
        get :move_lower_within_brand
      end
    end
  end

  # 全店舗一覧の並び替え
  resources :stores, only: %i[index] do
    member do
      get :move_higher
      get :move_lower
    end
  end
end
