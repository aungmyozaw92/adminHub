class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.includes(:roles).order(:name)
  end

  def show
  end

  def new
    @user = User.new
    @roles = Role.all
  end

  def create
    @user = User.new(user_params)
    @roles = Role.all

    if @user.save
      # Assign roles if any are selected
      if params[:user][:role_ids].present?
        selected_roles = Role.where(id: params[:user][:role_ids].reject(&:blank?))
        @user.roles = selected_roles
      end
      redirect_to admin_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @roles = Role.all
  end

  def update
    @roles = Role.all

    if @user.update(user_params)
      # Update roles if any are selected
      if params[:user][:role_ids].present?
        selected_roles = Role.where(id: params[:user][:role_ids].reject(&:blank?))
        @user.roles = selected_roles
      else
        @user.roles.clear
      end
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted_params = params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation, :avatar)

    # Remove password fields if they're blank (for updates)
    if params[:action] == "update" && permitted_params[:password].blank?
      permitted_params.delete(:password)
      permitted_params.delete(:password_confirmation)
    end

    permitted_params
  end
end
