require 'features/features_spec_helper'

describe "browse past voting rounds" do
  before do
    @oldest_voting_round = FactoryGirl.create(:voting_round, :completed, start_time: "2000-01-01 11:11:11", label: "label")
    @voting_round = FactoryGirl.create(:voting_round, :completed)
    @live_voting_round = FactoryGirl.create(:voting_round, :other, :live)
  end
  it "is linked to from the home page" do
    home = Home.new
    home.load
    home.should have_link("Voting for " + @voting_round.label, href: voting_round_path(@voting_round.id))
  end

  it "has links to previous and next voting rounds" do

  end
end
