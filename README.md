# Decollte Photography
<img width="1670" alt="トップビュー" src="https://github.com/user-attachments/assets/78a6b951-087d-40ec-b48a-0e1194c4f1be">
<img width="1670" alt="トップビュー" src="https://github.com/user-attachments/assets/81c7657d-6e11-48eb-999e-0846d4d41541">

# 概要
技術課題のアプリケーションです。

# 仕様
#### トップページ
  - ブランド一覧(名前のみでよい)を表示する
    - 名前はリンクになっており、下に記すブランドの店舗一覧ページに遷移する

#### ブランドの店舗一覧ページ
  - `/aqua`, `/tvb` のようにブランドごとに固有のパスとする
    - パスは管理画面でブランドを新規に作成するときに管理者が入力する
      - ブランド作成後のパスの変更は不可
  - そのブランドの店舗一覧(名前のみでよい)を表示する
  - 店舗の並び順は管理画面から変更可能

#### 管理者専用ページ
  - 特権管理者と一般管理者(後述)しかアクセスできない
  - 特権管理者
    - 1名のみでユーザ名 `admin`、パスワード `UMtDj4ZBv%&d@Tzh` で認証を行う
    - 全ての操作が行える
  - 一般管理者
    - 特権管理者がユーザ名とパスワードを指定して作成する
      - そのユーザ名とパスワードで認証を行う
    - ブランドの新規作成と店舗の並び順の変更のみを行える

# 使用技術

#### バックエンド
- ruby 3.4.2
- Rails 8.0.2
- sqlite3 2.6.0

#### 認証
- 独自実装（パスワードのハッシュ化には、BCryptを使用）
- セッションベースの認証（cookiesを利用）

#### テスト
- RSpec（コントローラー、モデルのみ実施）

#### その他
- rubocop（コード整形）

# 画面一覧
#### トップページ（ブランド一覧画面）
- 一般ユーザー向け（未ログイン状態）
<img width="1665" alt="トップページ（ブランド一覧画面）一般ユーザー向け（未ログイン状態）" src="https://github.com/user-attachments/assets/78a6b951-087d-40ec-b48a-0e1194c4f1be">
<img width="1665" alt="トップページ（ブランド一覧画面）一般ユーザー向け（未ログイン状態）" src="https://github.com/user-attachments/assets/81c7657d-6e11-48eb-999e-0846d4d41541">

- 管理者用
<img width="1665" alt="ブランド一覧" src="https://github.com/user-attachments/assets/61816af2-97e8-4b6c-b40e-56ecd488b1ab">

#### 管理者ログイン画面
<img width="1665" alt="管理者ログイン" src="https://github.com/user-attachments/assets/2d7a6ee9-17ba-425e-88fe-89b525f3d0e5">

#### ダッシュボード
- 特権管理者用
<img width="1665" alt="ダッシュボード（特権管理者用）" src="https://github.com/user-attachments/assets/fa7e6c21-411c-40b3-8f7f-a85b6b3770a8">

- 一般管理者用
<img width="1665" alt="ダッシュボード（一般管理者用）" src="https://github.com/user-attachments/assets/39a7ee26-e360-449c-9fbe-851821219089">


#### 管理者一覧画面（※特権管理者限定）
<img width="1665" alt="管理者一覧" src="https://github.com/user-attachments/assets/17a14558-4f00-420f-9418-a92d69fc2abf">

#### 全店舗一覧画面
<img width="1665" alt="全店舗一覧" src="https://github.com/user-attachments/assets/e5d9f601-8107-48ab-9af2-6e9f264dc576">
<img width="1665" alt="全店舗一覧" src="https://github.com/user-attachments/assets/e20466ca-8603-4599-8b33-e2c81dfef876">
<img width="1665" alt="全店舗一覧" src="https://github.com/user-attachments/assets/36d10726-b7c8-4b2e-8860-cd66f4381b72">

### ER図
<img width="1665" alt="ER図" src="https://github.com/user-attachments/assets/9b401e4b-6e51-430d-bfcb-e57bdc6eab6a">

# セットアップ手順
1. リポジトリをクローン
```
git clone https://github.com/ASAMI-TAKAOKA/decollte_photography_app.git
cd decollte_photography_app
bundle install
```

2. データベースのセットアップ
```
bin/rails db:create db:migrate db:seed
※SQLite3がインストールされていない場合は、「brew install sqlite3」を実行してください。
```

3. サーバー起動
```
bin/rails s
※http://localhost:3000 にアクセスしていただき、ご確認いただけますと幸いです。
```
