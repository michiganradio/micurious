require 'spec_helper'

describe Admin::VotingRoundsHelper do

  describe "can_remove_question? method" do
    context "when voting round has New status" do
      it "returns true" do
        @voting_round = double(:voting_round, status: VotingRound::Status::New)
        helper.can_remove_question?.should be_true
      end
    end

    context "when the voting round status is not New" do
      it "returns false" do
        @voting_round = double(:voting_round, status: VotingRound::Status::Live)
        helper.can_remove_question?.should be_false
      end
    end
  end

end
