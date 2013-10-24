require 'spec_helper'

describe Admin::VotingRoundsHelper do

  context "can_remove_question?" do
    it "can remove question if voting round has New status" do
      @voting_round = double(:voting_round, status: VotingRound::Status::New)
      helper.can_remove_question?.should be_true
    end

    it "can not remove question if voting round does not have New statusr" do
      @voting_round = double(:voting_round, status: VotingRound::Status::Live)
      helper.can_remove_question?.should be_false
    end
  end
end
