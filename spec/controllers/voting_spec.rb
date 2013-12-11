=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Voting do
  describe "vote helper function" do

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

    context "when it is the user's first vote for this voting round" do
      before do
        @return_value = Voting.vote(@cookies, @params)
      end

      it "returns true" do
        @return_value.should be_true
      end

      it "increments the vote number of the voting round question" do
        @voting_round_question.reload.vote_number.should eq 1
      end

      it "sets a user's browser's cookie with the voting round id" do
        expect(@permanent[:voting_round_id]).to eq @voting_round.id
      end

      it "sets a user's browser's cookie with the id of the question the user voted for" do
        expect(@permanent[:question_id]).to eq @question.id
      end
    end

    context "when it is the user's second (attempted) vote for this voting around" do
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

    context "when the user has voted, and is now voting in a new voting round" do
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

      it "increments the vote number of the voting round question" do
        @new_voting_round_question.reload.vote_number.should eq 1
      end

      it "sets a user's browser's cookie with the voting round id" do
        expect(@permanent[:voting_round_id]).to eq @new_voting_round.id
      end

      it "sets a user's browser's cookie with the id of the question the user voted for" do
        expect(@permanent[:question_id]).to eq @new_question.id
      end
    end
  end
end
