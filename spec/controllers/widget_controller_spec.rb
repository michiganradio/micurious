require 'spec_helper'

describe WidgetController do

  describe "GET voting widget" do
    it "assigns questions" do
      voting_round = double(:voting_round)
      voting_rounds = [voting_round]
      questions = [double(:question)]
      VotingRound.stub(:where).and_return(voting_rounds)
      get :vote_widget
      assigns(:voting_round).should eq voting_round
      response.headers["X-Frame-Options"].should eq "ALLOWALL"
    end
  end

  describe "POST vote" do
    context "vote success" do
      it "redirects to root path" do
        Voting.stub(:vote).and_return(true)
        post :vote
        response.should redirect_to(vote_widget_path)
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

  describe "GET ask widget" do
    it "gets the ask question widget page without issue" do
      get :ask_widget
      response.status.should be 200
    end
  end
end
