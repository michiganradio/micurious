require 'spec_helper'

describe "voting_rounds/index" do
  before(:each) do
    assign(:voting_rounds, [
      stub_model(VotingRound),
      stub_model(VotingRound)
    ])
  end

  it "renders a list of voting_rounds" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
