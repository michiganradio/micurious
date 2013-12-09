=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Admin
  module SessionsHelper

    def sign_in(admin)
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      admin.update_attribute(:remember_token, User.encrypt(remember_token))
      self.current_admin = admin
    end

    def sign_out
      cookies.delete :remember_token
      self.current_admin = nil
    end

    def signed_in?
      !current_admin.nil?
    end

    def current_admin=(admin)
      @current_admin = admin
    end

    def current_admin
      remember_token = User.encrypt(cookies[:remember_token])
      @current_admin ||= User.find_by(remember_token: remember_token)
    end

    def current_admin?
      current_admin.admin
    end
  end
end
