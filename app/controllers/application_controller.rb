class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :admin_logged_in?

  private

  def current_user
    return nil if session[:admin_user_id]&.blank?

    @admin_user ||= AdminUser.find(session[:admin_user_id])
  end

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

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless current_user.super_admin?
      redirect_to admin_root_path, alert: "特権管理者のみアクセスが可能です。"
    end
  end
end
