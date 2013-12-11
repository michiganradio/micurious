=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::CategoriesController < Admin::AdminController
  before_action :set_admin_category, only: [:show, :edit, :update, :deactivate, :activate]
  before_action :admin_privilege_check, only: [:new, :edit, :deactivate, :activate]

  # GET /admin/categories
  def index
    @admin_categories = Category.all
  end

  # GET /admin/categories/1
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
    @admin_category.update_attribute(:active, false)
    respond_to do |format|
      format.html { redirect_to admin_categories_url }
    end
  end

  def activate
    @admin_category.update_attribute(:active, true)
    redirect_to admin_categories_url
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
