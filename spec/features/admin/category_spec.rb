=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "activate deactivated category" do
  it "changes the active status" do
    FactoryGirl.create(:category)
    signin_as_admin
    @admin_categories = Admin::Categories.new
    @admin_categories.load
    @admin_categories.activate_links[0].click
    @admin_categories.should be_displayed
    @admin_categories.load
    expect(@admin_categories.active_labels[0].text).to eq "true"
  end
end
