=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Admin
  class SessionsController < Admin::AdminController
    skip_before_action :signed_in_admin
    def new

    end

    def create
      admin = User.find_by(username: params[:session][:username].downcase)
      if admin && admin.authenticate(params[:session][:password])
        sign_in admin
        redirect_to admin_path
      else
        flash.now[:error] = 'Invalid username/password combination'
        render 'new'
      end
    end

    def destroy
    end
  end
end
