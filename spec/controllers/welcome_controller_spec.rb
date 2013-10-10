require 'spec_helper'

describe WelcomeController do

  describe "GET home" do
    it "gets the home page" do
      get :home, {}, {}
    end
  end

  describe "POST vote" do

    before do
      @voting_round = FactoryGirl.create(:voting_round)
      @question = FactoryGirl.create(:question)
      @voting_round_question = FactoryGirl.create(:voting_round_question,
                                                  question_id: @question.id,
                                                  voting_round_id: @voting_round.id)
      post :vote, :question_id => @question.id
    end

    describe "first vote" do
      it "asks voting round question to increment vote" do
        @voting_round_question.reload.vote_number.should eq 1
      end

      it "sets cookie with voting round id of vote" do
        expect(cookies.permanent[:voting_round_id]).to eq @voting_round.id 
      end

      it "sets cookie with question id of vote" do
        expect(cookies.permanent[:question_id]).to eq @question.id 
      end
    end

    describe "second vote" do
      before do
        post :vote, :question_id => @question.id
      end  
      
      it "flash already voted error" do
        flash[:error].should eq 'You can only vote once.'
      end

      it "does not increment vote" do
        @voting_round_question.reload.vote_number.should eq 1
      end
    end
  end
end
