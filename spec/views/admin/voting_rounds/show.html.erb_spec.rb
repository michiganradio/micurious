require 'spec_helper'

describe "admin/voting_rounds/show" do
  before(:each) do
    @voting_round = assign(:voting_round, stub_model(VotingRound))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
