require 'spec_helper'

describe WelcomeController do

  describe "GET home" do
    it "gets the home page" do
      get :home, {}, {}
    end
  end

  describe "POST vote" do
    it "asks voting round question to increment vote" do
      voting_round = FactoryGirl.create(:voting_round)
      question = FactoryGirl.create(:question)
      voting_round_question = FactoryGirl.create(:voting_round_question, question_id: question.id, voting_round_id: voting_round.id)
      post :vote, :question_id => question.id
      voting_round_question.reload.vote_number.should eq 1
    end
  end
end
