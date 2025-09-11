class Admin::PermissionsController < Admin::BaseController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  def index
    @search = params[:search]
    @permissions = Permission.all
    
    # Apply search filter if search parameter is present
    if @search.present?
      @permissions = @permissions.where(
        "name LIKE ? OR description LIKE ?", 
        "%#{@search}%", "%#{@search}%"
      )
    end
    
    # Apply pagination and ordering
    @permissions = @permissions.order(:name).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      respond_to do |format|
        format.html { redirect_to admin_permissions_path, notice: "Permission was successfully created." }
        format.turbo_stream { 
          flash[:notice] = "Permission was successfully created."
          redirect_to admin_permissions_path
        }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @permission.update(permission_params)
      respond_to do |format|
        format.html { redirect_to admin_permissions_path, notice: "Permission was successfully updated." }
        format.turbo_stream { 
          flash[:notice] = "Permission was successfully updated."
          redirect_to admin_permissions_path
        }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @permission.destroy
    respond_to do |format|
      format.html { redirect_to admin_permissions_path, notice: "Permission was successfully deleted." }
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.append("toast-container", partial: "shared/toast", locals: { type: "success", message: "Permission was successfully deleted.", duration: 5000 }),
          turbo_stream.remove("permission-row-#{@permission.id}")
        ]
      }
    end
  end

  private

  def set_permission
    @permission = Permission.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(:name, :description)
  end
end
