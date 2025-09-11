class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @search = params[:search]
    @users = User.includes(:roles)
    
    # Apply search filter if search parameter is present
    if @search.present?
      @users = @users.where(
        "name LIKE ? OR email LIKE ? OR phone LIKE ?", 
        "%#{@search}%", "%#{@search}%", "%#{@search}%"
      )
    end
    
    # Apply pagination and ordering
    @users = @users.order(:created_at).page(params[:page]).per(10)
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
      
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User was successfully created." }
        format.turbo_stream { 
          flash[:notice] = "User was successfully created."
          redirect_to admin_users_path
        }
      end
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
      
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User was successfully updated." }
        format.turbo_stream { 
          flash[:notice] = "User was successfully updated."
          redirect_to admin_users_path
        }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user_name = @user.name
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "#{user_name} was successfully deleted." }
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.append("toast-container", partial: "shared/toast", locals: { type: "success", message: "#{user_name} was successfully deleted.", duration: 5000 }),
          turbo_stream.remove("user-row-#{@user.id}")
        ]
      }
    end
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
