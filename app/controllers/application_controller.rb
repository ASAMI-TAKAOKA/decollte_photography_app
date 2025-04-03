class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # ログイン認証をチェックする
  def check_login
    unless session[:admin_user_id]
      redirect_to new_admin_session_path, alert: "ログインが必要です。"
    end
  end
end
