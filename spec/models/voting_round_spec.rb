require 'spec_helper'

describe VotingRound do
  describe "after save" do
    context "label is empty" do
      it "creates default label" do
        voting_round = VotingRound.new
        voting_round.save
        voting_round.reload.label.should == "Voting Round #{voting_round.id}"
      end
    end
  end

  it {should validate_uniqueness_of(:label).case_insensitive}

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

  context "validation" do
    it "disallows two live voting rounds" do
      FactoryGirl.create(:voting_round, status:VotingRound::Status::Live)
      expect { FactoryGirl.create(:voting_round, status:VotingRound::Status::Live) }.to raise_error
    end

    it "only validates the status when the new status is live" do
      FactoryGirl.create(:voting_round, status:VotingRound::Status::Live, label: "new label")
      expect { FactoryGirl.create(:voting_round) }.not_to raise_error
    end
  end
end
