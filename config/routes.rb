Rails.application.routes.draw do
  root to: "brands#index"

  # (Review: 指摘1)
  # 基本的にルーティングは `resources` メソッドのみ使ってください。


  # (Review: 指摘3)
  # 管理画面の機能はすべて、/adminのパス配下にしてもらえますか？(`/admin_users`ではなくて`/admin/users`もしくは`/admin/admin_users`となるべき)
  # `/brands/:brand_slug/stores/new`, `/stores/:id/move_higher_global`, `/brands/:brand_slug/stores/:id/move_higher_within_brand` なども `/admin` 内にあるべき。
  # また、`/admin/dashboard` は `/admin` にルーティングを変更してください。

  # 管理者ログイン関連
  get "admin/login", to: "admin_users#login", as: "admin_users_login"
  post "admin/login", to: "admin_users#login"
  delete "logout", to: "admin_users#logout", as: "admin_users_logout"
  resources :admin_users
  get "admin/dashboard", to: "admin_users#dashboard", as: "admin_dashboard"

  # (Review: 指摘4)
  # このルーティングだと、 `/brands/new` にアクセスするとブランドを生成できてしまいます。ブランドの生成は管理者のみが行えるべきです。
  # 管理者ではない未ログインのユーザが自由にブランドを生成できるといたずらにアクセスしてどんどん許可してないブランドが生成されないですか？
  # ブランドと店舗関連
  resources :brands, param: :slug do
    resources :stores, param: :id do
      # (Review: 指摘2)
      # param: :id という記述は不要です
      member do
        # (Review: 指摘5)
        # このルーティングだと、 `/brands/:brand_slug/stores/:id/move_higher_within_brand` にアクセスすると店舗の順番を変更できてしまいます。
        # `/brands/:brand_slug/stores/:id/move_higher_within_brand` の動きを見ると、以下のようにGETメソッドになってました。
        # 処理内容は、SQLでUPDATE文が発行されてましたので、このHTTPメソッドはPATCH(もしくはPOST)であるべきです。GETメソッドは参照するべきでサーバーの状態が変わってはいけません。
        # ```
        # Started GET "/brands/aqua/stores/1/move_higher_within_brand
        # ```
        get :move_higher_within_brand
        get :move_lower_within_brand
      end
    end
  end

  # 全店舗一覧の並び替え
  resources :stores, only: %i[index] do
    member do
      get :move_higher_global
      get :move_lower_global
    end
  end
end
