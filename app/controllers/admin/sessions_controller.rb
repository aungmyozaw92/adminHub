class Admin::SessionsController < ApplicationController
  layout "admin_login"

  def new
    redirect_to admin_dashboard_path if admin_logged_in?
  end

  def create
    user = authenticate_user(params[:email], params[:password])

    if user
      session[:user_id] = user.id
      session[:user_email] = user.email
      session[:user_name] = user.name
      redirect_to admin_dashboard_path, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_email] = nil
    session[:user_name] = nil
    redirect_to admin_login_path, notice: "You have been logged out"
  end

  private

  def authenticate_user(email, password)
    user = User.find_by(email: email.downcase)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end
