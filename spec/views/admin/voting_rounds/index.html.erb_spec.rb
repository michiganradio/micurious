require 'spec_helper'

describe "admin/voting_rounds/index" do
  before(:each) do
    assign(:voting_rounds, [
      stub_model(VotingRound),
      stub_model(VotingRound)
    ])
  end

  it "renders a list of voting_rounds" do
    render
  end
end
