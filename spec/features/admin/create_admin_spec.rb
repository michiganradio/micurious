=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "/admin/users/new" do
  before do
    signin_as_admin
    @admin_create = Admin::NewUser.new
    @admin_create.load
    @admin_create.username_field.set("rebecca")
    @admin_create.password_field.set("password")
    @admin_create.confirmation_field.set("password")
  end

  context "when the user being created is an admin" do
    it "is a user with admin privileges" do
      @admin_create.admin_field.set(true)
      @admin_create.create_user_button.click
      @admin_index_page = Admin::Users.new
      @admin_index_page.load
      @admin_index_page.users[1].should have_content("rebecca")
      @admin_index_page.users[1].should have_content("true")
    end
  end

  context "when the user being created is a reporter" do
    it "is a user without admin privileges" do
      @admin_create.admin_field.set(false)
      @admin_create.create_user_button.click
      @admin_index_page = Admin::Users.new
      @admin_index_page.load
      @admin_index_page.users[1].should have_content("rebecca")
      @admin_index_page.users[1].should have_content("false")
    end
  end
end
