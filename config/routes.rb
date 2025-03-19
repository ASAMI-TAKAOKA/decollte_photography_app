Rails.application.routes.draw do
  root to: "brands#index"

  # GET: ユーザーがログイン画面を開くときに使用
  get "admin/login", to: "admin_users#login", as: "admin_users_login"
  # POST: ログイン処理の実行時に使用
  post "admin/login", to: "admin_users#login"
  delete "logout", to: "admin_users#logout", as: "admin_users_logout"
  resources :admin_users
  get "admin/dashboard", to: "admin_users#dashboard", as: "admin_dashboard"
  resources :brands, param: :slug do
    resources :stores, param: :id do
      member do
        get :move_higher
        get :move_lower
      end
    end
  end
end
