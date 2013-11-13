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

  context "get previous voting round" do
    it "gets voting round that is completed and previous" do
      old_voting_round = FactoryGirl.create(:voting_round, :completed)
      current_voting_round = FactoryGirl.create(:voting_round, :live, :other)
      result = current_voting_round.get_previous
      result.should eq old_voting_round
    end
  end

  context "get next voting round" do
    it "gets voting round that is completed and previous" do
      old_voting_round = FactoryGirl.create(:voting_round, :completed)
      newer_voting_round = FactoryGirl.create(:voting_round, :live, :other)
      result = old_voting_round.get_next
      result.should eq newer_voting_round
    end
  end

  it "gives winner" do
    question = FactoryGirl.create(:question)
    question2 = FactoryGirl.create(:question, :other)
    voting_round  = FactoryGirl.create(:voting_round, questions: [question, question2])
    VotingRoundQuestion.where(question_id: question.id).first.update_attributes(vote_number: 5)
    voting_round.winner.should eq question
  end

  it "gets percentage" do
    question = FactoryGirl.create(:question)
    question2 = FactoryGirl.create(:question, :other)
    voting_round  = FactoryGirl.create(:voting_round, questions: [question, question2])
    VotingRoundQuestion.where(question_id: question.id).first.update_attributes(vote_number: 5)
    voting_round.vote_percentage(question).should eq 100
    voting_round.vote_percentage(question2).should eq 0
  end

  it "handles questions when there are no votes" do
    question = FactoryGirl.create(:question)
    voting_round = FactoryGirl.create(:voting_round, questions: [question])
    voting_round.vote_percentage(question).should eq 0
  end
end
