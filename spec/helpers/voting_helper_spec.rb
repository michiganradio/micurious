require 'spec_helper'

describe VotingHelper do

  before do
    @question = FactoryGirl.create(:question)
    @voting_round = FactoryGirl.create(:voting_round)
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
      @questions = [@question, @question2, @question3]
    end

    context "if not voted?" do
      specify "orders by shuffle" do
        helper.stub(:voted?).and_return(false)
        @questions.should_receive(:shuffle).and_return([@question2, @question, @question3])
        expect(helper.display_order(@questions)).to eq [@question2, @question, @question3]
      end
    end

    context "if voted?" do
      specify "orders by vote number, descending" do
        @voting_round_question = stub_model(VotingRoundQuestion, vote_number: 1)
        @voting_round_question2 = stub_model(VotingRoundQuestion, vote_number: 0)
        @voting_round_question3 = stub_model(VotingRoundQuestion, vote_number: 2)
        VotingRoundQuestion.stub(:find_by).with(question_id: 1).and_return(@voting_round_question)
        VotingRoundQuestion.stub(:find_by).with(question_id: 2).and_return(@voting_round_question2)
        VotingRoundQuestion.stub(:find_by).with(question_id: 3).and_return(@voting_round_question3)
        helper.stub(:voted?).and_return(true)
        expect(helper.display_order(@questions)).to eq [@question3, @question, @question2]
      end
    end
  end
end
