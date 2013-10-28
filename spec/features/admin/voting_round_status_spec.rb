require 'features/features_spec_helper'

describe "Set voting round status" do
  before {signin_as_admin }

  it "has no voting round on main page before making voting round live" do
    voting_round = FactoryGirl.create(:voting_round)
    @home_page = Home.new
    @home_page.load
    expect(@home_page.has_voting_round?).to be_false
  end

  it "shows the live voting round on the home page" do
    voting_round = FactoryGirl.create(:voting_round)
    @edit_voting_round_page = Admin::EditVotingRound.new
    @edit_voting_round_page.load(id: voting_round.id)
    @edit_voting_round_page.status_dropdown.select(VotingRound::Status::Live)
    @edit_voting_round_page.update_button.click
    @home_page = Home.new
    @home_page.load
    expect(@home_page.has_voting_round?).to be_true
  end

  it "does not allow multiple live voting rounds" do
    live_voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
    voting_round = FactoryGirl.create(:voting_round)
    @edit_voting_round_page = Admin::EditVotingRound.new
    @edit_voting_round_page.load(id: voting_round.id)
    @edit_voting_round_page.status_dropdown.select(VotingRound::Status::Live)
    @edit_voting_round_page.update_button.click
    @edit_voting_round_page.body.should include "Only one voting round can have live status"
  end
end
