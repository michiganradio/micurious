=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe "admin/categories/new" do
  before(:each) do
    assign(:admin_category, stub_model(Category,
      :name => "MyString",
      :label => "MyString",
      :active => false
    ).as_new_record)
  end

  it "renders new admin_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_categories_path, "post" do
      assert_select "input#admin_category_name[name=?]", "admin_category[name]"
      assert_select "input#admin_category_label[name=?]", "admin_category[label]"
    end
  end
end
