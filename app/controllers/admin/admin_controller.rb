class Admin::AdminController < ApplicationController
  force_ssl if: :ssl_configured
  before_action :signed_in_admin
  layout 'admin/layouts/admin.html.erb'

  def signed_in_admin
    redirect_to admin_signin_path, notice: "Please sign in." unless signed_in?
  end

  def ssl_configured
    !Rails.env.development? && !Rails.env.test?
  end

  def admin_privilege_check
    unless current_admin.admin
      render :file => "public/401.html", :status => :unauthorized
      false
    else
      true
    end
  end
end
