Rails.application.routes.draw do
  root to: "home#index"

  # 管理者専用ページ
  get "admin_users/login", to: "admin_users#login", as: "admin_users_login"
  post "admin_users/login", to: "admin_users#login"
  resources :admin_users, only: [ :new, :create, :edit, :update, :destroy, :show ]
  get "admin/super_admin_dashboard", to: "admin_users#super_admin_dashboard", as: "admin_users_super_admin_dashboard"
  get "admin/regular_admin_dashboard", to: "admin_users#regular_admin_dashboard", as: "admin_users_regular_admin_dashboard"
  resources :brands, only: [ :index, :new, :create, :destroy, :show ]
end
