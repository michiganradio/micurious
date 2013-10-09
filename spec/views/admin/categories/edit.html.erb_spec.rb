require 'spec_helper'

describe "admin/categories/edit" do
  before(:each) do
    @admin_category = assign(:admin_category, stub_model(Category,
      :name => "MyString",
      :label => "MyString",
      :active => false
    ))
  end

  it "renders the edit admin_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_category_path(@admin_category), "post" do
      assert_select "input#category_name[name=?]", "category[name]"
      assert_select "input#category_label[name=?]", "category[label]"
      assert_select "input#category_active[name=?]", "category[active]"
    end
  end
end
