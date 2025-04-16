class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :admin_logged_in?

  def current_user
    return nil unless session[:admin_user_id].present?

    @admin_user ||= AdminUser.find(session[:admin_user_id])
  end

  def admin_logged_in?
    session[:admin_user_id].present?
  end
end
