require 'spec_helper'

describe "admin/users/index" do
  before(:each) do
    assign(:admins, [
      stub_model(User,
        :username => "Username",
        :password => "Password"
      ),
      stub_model(User,
        :username => "Username",
        :password => "Password"
      )
    ])
  end

  it "renders a list of admins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
  end
end
