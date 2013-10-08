require 'spec_helper'

describe "admin/voting_rounds/edit" do
  before(:each) do
    @voting_round = assign(:voting_round, stub_model(VotingRound))
  end

  it "renders the edit voting_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_voting_round_path(@voting_round), "post" do
    end
  end
end
