require 'spec_helper'

describe Voting do
  describe "vote" do

    before do
      @voting_round = FactoryGirl.create(:voting_round)
      @question = FactoryGirl.create(:question)
      @voting_round_question = FactoryGirl.create(:voting_round_question,
                                                  question_id: @question.id,
                                                  voting_round_id: @voting_round.id)
      @cookies = {}
      @permanent = {}
      @cookies.stub(:permanent).and_return(@permanent)
      @params = { question_id: @question.id, voting_round_id: @voting_round.id }

    end

    describe "first vote" do
      before do
        @return_value = Voting.vote(@cookies, @params)
      end

      it "returns true" do
        @return_value.should be_true
      end

      it "asks voting round question to increment vote" do
        @voting_round_question.reload.vote_number.should eq 1
      end

      it "sets cookie with voting round id of vote" do
        expect(@permanent[:voting_round_id]).to eq @voting_round.id
      end

      it "sets cookie with question id of vote" do
        expect(@permanent[:question_id]).to eq @question.id
      end
    end

    describe "second vote" do
      before do
        Voting.vote(@cookies, @params)
        @return_value = Voting.vote(@cookies, @params)
      end

      it "returns false" do
        @return_value.should be_false
      end

      it "does not increment vote" do
        @voting_round_question.reload.vote_number.should eq 1
      end
    end

    describe "voting in new voting round" do
      before do
        Voting.vote(@cookies, @params)
        @new_voting_round = FactoryGirl.create(:voting_round, :other)
        @new_question = FactoryGirl.create(:question, :other)
        @new_voting_round_question = FactoryGirl.create(:voting_round_question,
                                                        question_id: @new_question.id,
                                                        voting_round_id: @new_voting_round.id)
        @params = { question_id: @new_question.id,
                    voting_round_id: @new_voting_round.id }
        @return_value = Voting.vote(@cookies, @params)
      end

      it "returns true" do
        @return_value.should be_true
      end

      it "asks voting round question to increment vote" do
        @new_voting_round_question.reload.vote_number.should eq 1
      end

      it "sets cookie with voting round id of vote" do
        expect(@permanent[:voting_round_id]).to eq @new_voting_round.id
      end

      it "sets cookie with question id of vote" do
        expect(@permanent[:question_id]).to eq @new_question.id
      end
    end
  end
end
