class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @search = params[:search]
    @categories = Category.includes(:parent_category, :subcategories)
    
    # Apply search filter if search parameter is present
    if @search.present?
      @categories = @categories.where(
        "name LIKE ? OR description LIKE ?", 
        "%#{@search}%", "%#{@search}%"
      )
    end
    
    # Filter by parent category if specified
    if params[:parent_id].present?
      @categories = @categories.where(parent_category_id: params[:parent_id])
    end
    # Show all categories by default (no filtering)
    
    # Apply pagination and ordering
    @categories = @categories.order(:name).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @category = Category.new
    @category.parent_category_id = params[:parent_id] if params[:parent_id].present?
    @parent_categories = Category.all.order(:name)
  end

  def create
    @category = Category.new(category_params)
    @parent_categories = Category.all.order(:name)

    if @category.save
      respond_to do |format|
        format.html { redirect_to admin_categories_path, notice: "Category was successfully created." }
        format.turbo_stream { 
          flash[:notice] = "Category was successfully created."
          redirect_to admin_categories_path
        }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @parent_categories = Category.where.not(id: @category.id).order(:name)
  end

  def update
    @parent_categories = Category.where.not(id: @category.id).order(:name)

    if @category.update(category_params)
      respond_to do |format|
        format.html { redirect_to admin_categories_path, notice: "Category was successfully updated." }
        format.turbo_stream { 
          flash[:notice] = "Category was successfully updated."
          redirect_to admin_categories_path
        }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.subcategories.any?
      redirect_to admin_categories_path, alert: "Cannot delete category with subcategories. Please delete subcategories first."
    else
      @category.destroy
      respond_to do |format|
        format.html { redirect_to admin_categories_path, notice: "Category was successfully deleted." }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.append("toast-container", partial: "shared/toast", locals: { type: "success", message: "Category was successfully deleted.", duration: 5000 }),
            turbo_stream.remove("category-row-#{@category.id}")
          ]
        }
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :parent_category_id)
  end
end
