require 'spec_helper'

describe WelcomeController do

  describe "GET home" do
    before do
      subject.stub(:load_categories)
    end

    it "loads the categories" do
      subject.should_receive(:load_categories)
      get :home, {}, {}
    end

    it "assigns active voting round" do
      voting_round = double(:voting_round)
      VotingRound.stub(:where).with(status: VotingRound::Status::Live).and_return([voting_round])
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
