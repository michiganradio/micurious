require 'spec_helper'

describe "admin/categories/show" do
  before(:each) do
    @admin_category = assign(:admin_category, stub_model(Category,
      :name => "Name",
      :label => "Label",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Label/)
    rendered.should match(/false/)
  end
end
