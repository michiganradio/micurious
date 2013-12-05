=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe VotingRound do
  describe "after update" do
     context "status is initially live" do
      context "status is changed to completed" do
        it "updates the winning question status to Investigated" do
          question = FactoryGirl.create(:question)
          voting_round = FactoryGirl.create(:voting_round,
                                            questions: [question],
                                            status: VotingRound::Status::Live)
          expect {
            voting_round.status = VotingRound::Status::Completed
            voting_round.save!
          }.to change(question, :status).to(Question::Status::Investigating)
        end
      end

      context "status is not changed to Completed" do
        it "does not change the winning question status" do
          question = FactoryGirl.create(:question)
          voting_round = FactoryGirl.create(:voting_round,
                                            questions: [question],
                                            status: VotingRound::Status::Live)
          expect {
            voting_round.save!
          }.not_to change(question, :status).from(Question::Status::New)
        end
      end
    end

    context "when status is not initially live" do
      it "does not change the winning question status" do
        question = FactoryGirl.create(:question)
        voting_round = FactoryGirl.create(:voting_round,
                                          questions: [question],
                                          status: VotingRound::Status::New)
        expect {
          voting_round.status = VotingRound::Status::Completed
          voting_round.save!
        }.not_to change(question, :status).from(Question::Status::New)
      end
    end
  end

  describe "after save" do
        context "public label is empty" do
      it "creates default public label" do
        voting_round = VotingRound.new
        voting_round.save
        voting_round.reload.private_label.should eq "Voting Round #{voting_round.id}"
      end
    end

    context "private label is empty" do
      it "creates default private label" do
        voting_round = VotingRound.new
        voting_round.save
        voting_round.reload.private_label.should eq "Voting Round #{voting_round.id}"
      end
    end
  end

  it {should validate_uniqueness_of(:public_label).case_insensitive}
  it {should validate_uniqueness_of(:private_label).case_insensitive}

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
    it "only validates the status when the new status is live" do
      FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
      expect { FactoryGirl.create(:voting_round) }.not_to raise_error
    end
  end

  context "get previous voting round" do
    it "gets voting round that is completed and previous" do
      old_voting_round = FactoryGirl.create(:voting_round, :completed)
      current_voting_round = FactoryGirl.create(:voting_round, :live, :other)
      result = current_voting_round.previous
      result.should eq old_voting_round
    end
  end

  context "get next voting round" do
    it "gets voting round that is completed and previous" do
      old_voting_round = FactoryGirl.create(:voting_round, :completed)
      newer_voting_round = FactoryGirl.create(:voting_round, :live, :other)
      result = old_voting_round.next
      result.should eq newer_voting_round
    end
  end

  context "winner" do
    it "gives winner" do
      question = FactoryGirl.create(:question)
      question2 = FactoryGirl.create(:question, :other)
      voting_round  = FactoryGirl.create(:voting_round, questions: [question, question2])
      VotingRoundQuestion.where(question_id: question.id).first.update_attributes(vote_number: 5)
      voting_round.winner.should eq [question]
    end

    it "returns nil when there are no questions" do
      voting_round = FactoryGirl.create(:voting_round)
      voting_round.winner.should eq []
    end

    it "returns tied winners " do
      question = FactoryGirl.create(:question)
      question2 = FactoryGirl.create(:question, :other)
      voting_round  = FactoryGirl.create(:voting_round, questions: [question, question2])
      VotingRoundQuestion.where(question_id: question.id).first.update_attributes(vote_number: 5)
      VotingRoundQuestion.where(question_id: question2.id).first.update_attributes(vote_number: 5)
      voting_round.winner.should =~ [question, question2]
    end
  end

  it "gets percentage" do
    question = FactoryGirl.create(:question)
    question2 = FactoryGirl.create(:question, :other)
    voting_round  = FactoryGirl.create(:voting_round, questions: [question, question2])
    VotingRoundQuestion.where(question_id: question.id).first.update_attributes(vote_number: 5)
    VotingRoundQuestion.where(question_id: question2.id).first.update_attributes(vote_number: 4)
    voting_round.vote_percentage(question).should eq 56
    voting_round.vote_percentage(question2).should eq 44
  end

  it "handles questions when there are no votes" do
    question = FactoryGirl.create(:question)
    voting_round = FactoryGirl.create(:voting_round, questions: [question])
    voting_round.vote_percentage(question).should eq 0
  end

  describe "before update" do
    context "existing live voting round" do
      it "makes old voting round completed and new voting round live" do
         old_voting_round = double(:voting_round, id: 1, status: VotingRound::Status::Live)
         voting_round = VotingRound.create
         VotingRound.should_receive(:where).with("status = ? AND id != ?", VotingRound::Status::Live, voting_round.id).and_return([old_voting_round])
         old_voting_round.should_receive(:update!).with({:status => VotingRound::Status::Completed})
         voting_round.update!({:status  => VotingRound::Status::Live})
         voting_round.status.should == VotingRound::Status::Live
      end
    end

    context "no live voting rounds" do
      it "makes new voting round live" do
         voting_round = VotingRound.create
         VotingRound.should_receive(:where).with("status = ? AND id != ?", VotingRound::Status::Live, voting_round.id).and_return([])
         voting_round.update!({:status  => VotingRound::Status::Live})
         voting_round.status.should == VotingRound::Status::Live
      end

    end
  end
end
