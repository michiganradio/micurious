=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe VotingHelper do

  before do
    @question = FactoryGirl.create(:question)
    FactoryGirl.create(:voting_round)
  end

  specify "#last_vote?" do
    cookies.permanent[:question_id] = @question.id
    expect(last_vote?(@question.id)).to eq true
    expect(last_vote?(-1)).to eq false
  end


  specify "#voted?" do
    cookies.permanent[:voting_round_id] = VotingRound.last.id.to_i
    expect(voted?).to eq true
  end

  describe "#display_order" do
    before(:each) do
      @question = stub_model(Question, id: 1)
      @question2 = stub_model(Question, id: 2)
      @question3 = stub_model(Question, id: 3)
      @voting_round = stub_model(VotingRound, id: 0, questions: [@question, @question2, @question3])
    end

    context "when not voted?" do
      specify "orders by shuffle" do
        helper.stub(:voted?).and_return(false)
        @voting_round.questions.should_receive(:shuffle).and_return([@question2, @question, @question3])
        expect(helper.display_order(@voting_round.questions, @voting_round.id)).to eq [@question2, @question, @question3]
      end
    end

    context "when voted?" do
      specify "orders by vote number, descending" do
        @voting_round_question = stub_model(VotingRoundQuestion, vote_number: 1)
        @voting_round_question2 = stub_model(VotingRoundQuestion, vote_number: 0)
        @voting_round_question3 = stub_model(VotingRoundQuestion, vote_number: 2)
        VotingRoundQuestion.stub(:where).with(question_id: 1, voting_round_id: @voting_round.id).and_return([@voting_round_question])
        VotingRoundQuestion.stub(:where).with(question_id: 2, voting_round_id: @voting_round.id).and_return([@voting_round_question2])
        VotingRoundQuestion.stub(:where).with(question_id: 3, voting_round_id: @voting_round.id).and_return([@voting_round_question3])
        helper.stub(:voted?).and_return(true)
        expect(helper.display_order(@voting_round.questions, @voting_round.id)).to eq [@question3, @question, @question2]
      end
    end
  end
end
