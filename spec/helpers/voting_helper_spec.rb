require 'spec_helper'

describe VotingHelper do

  before(:each) do 
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

  describe "#sort_proc" do
    before do
      @question2 = FactoryGirl.create(:question)
      @voting_round.add_question(@question)
      @voting_round.add_question(@question2)
      VotingRoundQuestion.find_by(question_id: @question2.id).update_attributes(vote_number: 1) 
    end
   
    context "if voted?" do
      specify "orders by greatest voting number" do
        cookies.permanent[:voting_round_id] = VotingRound.last.id
        expect(@voting_round.questions.sort &sort_proc).to eq [@question2, @question]
      end
    end 

    context "if not voted?" do
      specify "orders by least id" do
        FactoryGirl.create(:voting_round)
        expect(@voting_round.questions.sort &sort_proc).to eq [@question, @question2]
      end
    end
  end
end
