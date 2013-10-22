require 'spec_helper'

describe VotingRound do
  describe "after save" do
    context "label is empty" do
      it "creates default label" do
        voting_round = VotingRound.new
        voting_round.stub(:id).and_return(1)
        voting_round.should_receive(:update_attributes).with(label: "Voting Round " + voting_round.id.to_s)
        voting_round.save
      end
    end
  end

  context "voting round question" do
    context "add_question" do
      it "adds a new question to the voting round" do
        voting_round  = VotingRound.new
        question = Question.new
        voting_round.add_question(question)
        voting_round.questions.first.should == question
      end
    end

    context "association" do
      it "saves the association" do
        voting_round = FactoryGirl.create(:voting_round)
        voting_round.questions << FactoryGirl.create(:question)
        voting_round.reload.questions.size.should ==  1
        voting_round.voting_round_questions.size.should == 1
      end
    end
  end
end
