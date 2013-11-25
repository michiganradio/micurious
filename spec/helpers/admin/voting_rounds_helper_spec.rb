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

  describe "#convert_time" do
    it "converts from military time" do
      @voting_round = double(:voting_round, start_time: DateTime.new(2013, 3, 2, 11, 0, 0))
      @voting_round.start_time.stub(:strftime).and_return("March 2, 2013 at 11am")
      helper.convert_time(@voting_round.start_time).should eq "March 2, 2013 at 11am"
    end

    it "converts a nil time" do
      @voting_round = VotingRound.new(start_time: nil)
      helper.convert_time(@voting_round.start_time).should eq ""
    end
  end
end
