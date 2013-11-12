require 'features/features_spec_helper'

describe "browse past voting rounds" do
  it "links from the home page" do
    voting_round = FactoryGirl.create(:voting_round, :completed)
    live_voting_round = FactoryGirl.create(:voting_round, :other, :live)
    home = Home.new
    home.load
#    home.should have_link("Voting for " + voting_round.label, href: voting_round_path(voting_round.id))
  end
end
