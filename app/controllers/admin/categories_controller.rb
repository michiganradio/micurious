class Admin::CategoriesController < ApplicationController
  before_action :set_admin_category, only: [:show, :edit, :update, :deactivate]

  # GET /admin/categories
  # GET /admin/categories.json
  def index
    @admin_categories = Category.all
  end

  # GET /admin/categories/1
  # GET /admin/categories/1.json
  def show
  end

  # GET /admin/categories/new
  def new
    @admin_category = Category.new
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # POST /admin/categories
  # POST /admin/categories.json
  def create
    @admin_category = Category.new(admin_category_params)

    respond_to do |format|
      if @admin_category.save
        format.html { redirect_to admin_category_url(@admin_category), notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/categories/1
  # PATCH/PUT /admin/categories/1.json
  def update
    respond_to do |format|
      if @admin_category.update(admin_category_params)
        format.html { redirect_to admin_category_url(@admin_category), notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/categories/1
  def deactivate
    @admin_category.update_attribute(:active, false)
    respond_to do |format|
      format.html { redirect_to admin_categories_url }
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
