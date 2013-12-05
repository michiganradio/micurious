=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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
