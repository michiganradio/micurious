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

    it "assigns active voting round" do
      voting_round = double(:voting_round)
      VotingRound.stub(:where).with(status: VotingRound::Status::Live).and_return([voting_round])
      Category.stub(:all).and_return([])
      get :home, {}, {}
      assigns(:voting_round).should eq voting_round
    end
  end

  describe "POST vote" do

    context "vote success" do
      it "redirects to root path" do
        Voting.stub(:vote).and_return(true)
        post :vote
        response.should redirect_to(root_path)
      end
    end

    context "vote failure" do
      it "renders with status 409" do
        Voting.stub(:vote).and_return(false)
        post :vote
        response.status.should be 409
      end
    end
  end
end
