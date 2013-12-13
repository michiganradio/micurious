=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Admin::VotingRoundsHelper do

  describe "#can_remove_question?" do
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
