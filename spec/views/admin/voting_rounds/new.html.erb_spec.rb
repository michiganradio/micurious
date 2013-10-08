require 'spec_helper'

describe "admin/voting_rounds/new" do
  before(:each) do
    assign(:voting_round, stub_model(VotingRound).as_new_record)
  end

  it "renders new voting_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_voting_rounds_path, "post" do
    end
  end
end
