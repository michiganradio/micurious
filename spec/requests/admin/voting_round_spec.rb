require 'spec_helper'

describe "Admin::VotingRounds" do
  describe "GET /admin_voting_rounds" do
    it "displays voting round labels" do
      voting_round = FactoryGirl.create(:voting_round, label: "label text")
      get admin_voting_rounds_path
      expect(response.body).to include voting_round.label
    end
  end

end
