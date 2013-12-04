class Admin::CategoriesController < Admin::AdminController
  before_action :set_admin_category, only: [:show, :edit, :update, :deactivate]

  # GET /admin/categories
  def index
    @admin_categories = Category.all
  end

  # GET /admin/categories/1
  def show
  end

  # GET /admin/categories/new
  def new
    if admin_privilege_check
      @admin_category = Category.new
    end
   end

  # GET /admin/categories/1/edit
  def edit
    admin_privilege_check
  end

  # POST /admin/categories
  def create
    @admin_category = Category.new(admin_category_params)

    respond_to do |format|
      if @admin_category.save
        format.html { redirect_to admin_category_url(@admin_category), notice: 'Category was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /admin/categories/1
  def update
    respond_to do |format|
      if @admin_category.update(admin_category_params)
        format.html { redirect_to admin_category_url(@admin_category), notice: 'Category was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # POST /admin/categories/1
  def deactivate
    if admin_privilege_check
      @admin_category.update_attribute(:active, false)
      respond_to do |format|
        format.html { redirect_to admin_categories_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_category
      @admin_category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_category_params
      params.require(:admin_category).permit(:name, :label, :active)
    end
end
