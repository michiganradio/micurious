require 'spec_helper'

describe WelcomeController do

  describe "GET home" do
    it "gets the home page" do
      categories = [double(:category)]
      Category.stub(:all).and_return(categories)
      get :home, {}, {}
      assigns(:ask).should eq true
      assigns(:categories).should eq categories
    end
  end

  describe "POST vote" do

    before do
      @voting_round = FactoryGirl.create(:voting_round)
      @question = FactoryGirl.create(:question)
      @voting_round_question = FactoryGirl.create(:voting_round_question,
                                                  question_id: @question.id,
                                                  voting_round_id: @voting_round.id)
    end

    describe "first vote" do
      before do
        post :vote, :question_id => @question.id,
                    :voting_round_id => @voting_round.id
      end

      it "asks voting round question to increment vote" do
        @voting_round_question.reload.vote_number.should eq 1
      end

      it "sets cookie with voting round id of vote" do
        expect(cookies.permanent[:voting_round_id]).to eq @voting_round.id
      end

      it "sets cookie with question id of vote" do
        expect(cookies.permanent[:question_id]).to eq @question.id
      end

      describe "second vote" do
        before do
          post :vote, :question_id => @question.id,
                      :voting_round_id => @voting_round.id
        end

        it "returns 409 error" do
          response.status.should be 409
        end

        it "does not increment vote" do
          @voting_round_question.reload.vote_number.should eq 1
        end
      end
    end


    describe "voting in new voting round" do
      before do
        @new_voting_round = FactoryGirl.create(:voting_round)
        @new_question = FactoryGirl.create(:question, :other)
        @new_voting_round_question = FactoryGirl.create(:voting_round_question,
                                          question_id: @new_question.id,
                                          voting_round_id: @new_voting_round.id)
        post :vote, :question_id => @new_question.id,
                    :voting_round_id => @new_voting_round.id
      end

      it "asks voting round question to increment vote" do
        @new_voting_round_question.reload.vote_number.should eq 1
      end

      it "sets cookie with voting round id of vote" do
        expect(cookies.permanent[:voting_round_id]).to eq @new_voting_round.id
      end

      it "sets cookie with question id of vote" do
        expect(cookies.permanent[:question_id]).to eq @new_question.id
      end
    end
  end
end
