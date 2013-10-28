class Admin::AdminController < ApplicationController
  before_action :signed_in_admin
  layout 'admin/layouts/admin.html.erb'

  def signed_in_admin
    redirect_to admin_signin_path, notice: "Please sign in." unless signed_in?
  end
end
