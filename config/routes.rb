Rails.application.routes.draw do
  root to: 'home#index'

  # 管理者専用ページ
  get 'admin_users/login', to: 'admin_users#login', as: 'admin_users_login'
  post 'admin_users/login', to: 'admin_users#login'
  resources :admin_users, only: [:create, :update, :destroy]
  get 'admin_users/dashboard', to: 'admin_users#dashboard', as: 'admin_users_dashboard'
end
