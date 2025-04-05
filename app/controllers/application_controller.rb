class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :admin_logged_in?, :super_admin?, :regular_admin?

  private

  # ログイン認証をチェックする
  def check_login
    unless session[:admin_user_id]
      redirect_to new_admin_session_path, alert: "ログインが必要です。"
    end
  end

  # ログインしてるかどうかを判定する（true/false）
  def admin_logged_in?
    session[:admin_user_id].present?
  end

  def super_admin?
    session[:admin_role] == 1
  end

  def regular_admin?
    session[:admin_role] == 0
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。"
    end
  end
end
