class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin_login
  before_action :check_permission

  private

  def require_admin_login
    redirect_to admin_login_path unless current_user
  end

  def check_permission
    return if current_user&.admin? # Admin has all permissions
    
    # Map controller actions to permission names
    permission_name = case "#{controller_name}:#{action_name}"
    when 'dashboard:index'
      'dashboard:read'
    when 'users:index', 'users:show'
      'users:read'
    when 'users:new', 'users:create'
      'users:create'
    when 'users:edit', 'users:update'
      'users:update'
    when 'users:destroy'
      'users:delete'
    when 'roles:index', 'roles:show'
      'roles:read'
    when 'roles:new', 'roles:create'
      'roles:create'
    when 'roles:edit', 'roles:update'
      'roles:update'
    when 'roles:destroy'
      'roles:delete'
    when 'permissions:index', 'permissions:show'
      'permissions:read'
    when 'permissions:new', 'permissions:create'
      'permissions:create'
    when 'permissions:edit', 'permissions:update'
      'permissions:update'
    when 'permissions:destroy'
      'permissions:delete'
    when 'categories:index', 'categories:show'
      'categories:read'
    when 'categories:new', 'categories:create'
      'categories:create'
    when 'categories:edit', 'categories:update'
      'categories:update'
    when 'categories:destroy'
      'categories:delete'
    else
      "#{controller_name}:#{action_name}"
    end
    
    unless current_user&.can?(permission_name)
      # If user doesn't have permission for dashboard, redirect to login instead of creating a loop
      if permission_name == 'dashboard:read'
        redirect_to admin_login_path, alert: 'Access denied. You do not have permission to access the dashboard.'
      else
        redirect_to admin_dashboard_path, alert: 'Access denied. You do not have permission to perform this action.'
      end
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end

  helper_method :current_user
end
