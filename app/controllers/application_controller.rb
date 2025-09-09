class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def user_logged_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if user_logged_in?
  end

  def require_user_login
    unless user_logged_in?
      redirect_to admin_login_path, alert: "Please log in to access the admin area"
    end
  end

  # Keep the old method names for backward compatibility
  def admin_logged_in?
    user_logged_in?
  end

  def current_admin
    if current_user
      { id: current_user.id, email: current_user.email, name: current_user.name }
    else
      nil
    end
  end

  def require_admin_login
    require_user_login
  end

  helper_method :user_logged_in?, :current_user, :admin_logged_in?, :current_admin
end
