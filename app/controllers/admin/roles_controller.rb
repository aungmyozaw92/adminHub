class Admin::RolesController < Admin::BaseController

    before_action :set_role, only: [:show, :edit, :update, :destroy]

    def index
        
        @search = params[:search]
        @roles = Role.all
        # Apply search filter if search parameter is present
        if @search.present?
          @roles = @roles.where(
            "name LIKE ?", 
            "%#{@search}%%"
          )
        end
    
        # Apply pagination and ordering
        @roles = @roles.order(:created_at).page(params[:page]).per(10)
    end

    def show
        @role = Role.find(params[:id])
    end

    def new
        @role = Role.new
        @permissions = Permission.all.order(:name)
    end

    def create
        @role = Role.new(role_params)
        @permissions = Permission.all.order(:name)

        if @role.save
            # Assign permissions to role
            if params[:role][:permission_ids].present?
                selected_permissions = Permission.where(id: params[:role][:permission_ids].reject(&:blank?))
                @role.permissions = selected_permissions
            end
            
            respond_to do |format|
                format.html { redirect_to admin_roles_path, notice: "Role was successfully created." }
                format.turbo_stream { 
                    flash[:notice] = "Role was successfully created."
                    redirect_to admin_roles_path
                }
            end
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @permissions = Permission.all.order(:name)
    end

    def update
        @permissions = Permission.all.order(:name)

        if @role.update(role_params)
            # Update permissions
            if params[:role][:permission_ids].present?
                selected_permissions = Permission.where(id: params[:role][:permission_ids].reject(&:blank?))
                @role.permissions = selected_permissions
            else
                @role.permissions.clear
            end
            
            respond_to do |format|
                format.html { redirect_to admin_roles_path, notice: "Role was successfully updated." }
                format.turbo_stream { 
                    flash[:notice] = "Role was successfully updated."
                    redirect_to admin_roles_path
                }
            end
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @role = Role.find(params[:id])
        @role.destroy
        redirect_to admin_roles_path, notice: "Role was successfully destroyed."
    end

    private
    
    def set_role
        @role = Role.find(params[:id])
    end

    def role_params
        params.require(:role).permit(:name, :description)
    end
end
