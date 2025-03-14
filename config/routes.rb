Rails.application.routes.draw do
  root to: "admin_users#switch_bashboard_by_role"

  # GET: ユーザーがログイン画面を開くときに使用
  get "admin/login", to: "admin_users#login", as: "admin_users_login"
  # POST: ログイン処理の実行時に使用
  post "admin/login", to: "admin_users#login"
  delete "logout", to: "admin_users#logout", as: "admin_users_logout"
  resources :admin_users
  get "admin/super_admin_dashboard", to: "admin_users#super_admin_dashboard", as: "admin_users_super_admin_dashboard"
  get "admin/regular_admin_dashboard", to: "admin_users#regular_admin_dashboard", as: "admin_users_regular_admin_dashboard"
  resources :brands do
    resources :stores do
      member do
        get :move_higher
        get :move_lower
      end
    end
  end
end
