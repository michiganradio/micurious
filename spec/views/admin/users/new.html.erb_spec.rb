require 'spec_helper'

describe "admin's create admin page" do
  before(:each) do
    assign(:admin, stub_model(User,
      :username => "MyString",
      :password => "MyString"
    ).as_new_record)
  end

  it "renders new admin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_users_path, "post" do
      assert_select "input#admin_username[name=?]", "admin[username]"
      assert_select "input#admin_password[name=?]", "admin[password]"
    end
  end
end
