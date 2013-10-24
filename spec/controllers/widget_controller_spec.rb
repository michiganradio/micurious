require 'spec_helper'

describe WidgetController do

  describe "GET widget" do
    it "assigns questions" do
      voting_round = [double(:voting_round)]
      questions = [double(:question)]
      VotingRound.stub(:last).and_return(voting_round)
      voting_round.should_receive(:questions).and_return(questions)
      get :widget
      assigns(:questions).should eq questions
      assigns(:voting_round).should eq voting_round
    end
  end

  describe "POST vote" do
    context "vote success" do
      it "redirects to root path" do
        Voting.stub(:vote).and_return(true)
        post :vote
        response.should redirect_to(widget_path)
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
